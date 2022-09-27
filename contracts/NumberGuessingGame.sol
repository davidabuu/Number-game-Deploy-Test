// SPDX-License-Identifier: MIT
// An example of a consumer contract that relies on a subscription for funding.
pragma solidity ^0.8.7;
error NumberGuessingGame__NotEnoughEthEntered();
error NumberGuessingGame__YOU_FAILED_TRY_AGAIN(); 
import '@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol';
import '@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';

/**
 * Request testnet LINK and ETH here: https://faucets.chain.link/
 * Find information on LINK Token Contracts and get the latest ETH and LINK faucets here: https://docs.chain.link/docs/link-token-contracts/
 */

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */

contract NumberGuessingGame is VRFConsumerBaseV2, ConfirmedOwner {
     address private s_manager;
    uint256 public s_entranceFee = 0.01 ether;
    address [] public players;
    uint256 private correctNumber;
    address public s_recentWinner;
      mapping(address => bool) public paid;
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);

    struct RequestStatus {
        bool fulfilled; 
        bool exists;
        uint256[] randomWords;
    }
    mapping(uint256 => RequestStatus) public s_requests; 
    VRFCoordinatorV2Interface COORDINATOR;

  
    uint64 s_subscriptionId;
   
    uint256[] public requestIds;
    uint256 public lastRequestId;
    uint256 [] public correctNum;
    uint256 public newNum;
    bytes32 keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;

    uint32 callbackGasLimit = 100000;

    uint16 requestConfirmations = 3;

    uint32 numWords = 2;

    constructor(uint64 subscriptionId)
        VRFConsumerBaseV2(0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D)
        ConfirmedOwner(msg.sender)
    {
        COORDINATOR = VRFCoordinatorV2Interface(0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D);
        s_subscriptionId = subscriptionId;
    }

    // Assumes the subscription is funded sufficiently.
    function requestRandomWords() external onlyOwner returns (uint256 requestId) {
        // Will revert if subscription is not set and funded.
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        s_requests[requestId] = RequestStatus({randomWords: new uint256[](0), exists: true, fulfilled: false});
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords) internal override {
        require(s_requests[_requestId].exists, 'request not found');
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
      //  correctNum = _randomWords[0] % 10;
        emit RequestFulfilled(_requestId, _randomWords);
    }
function enterGame () public payable {
        if(msg.value < s_entranceFee){
            revert NumberGuessingGame__NotEnoughEthEntered();
        }
        paid[msg.sender] = true;
        players.push(msg.sender);
    }
    function guessTheNumber (uint256 guessedNum) public payable {
        require(paid[msg.sender], "Pls pay to enter the game");
        if(guessedNum == newNum){
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
          if(!success){
            revert NumberGuessingGame__YOU_FAILED_TRY_AGAIN();
          }else{
            s_recentWinner = msg.sender;
            players = new address payable[](0);

          }
        }


    }
    function getRequestStatus(uint256 _requestId) external returns (bool fulfilled, uint256[] memory randomWords) {
        require(s_requests[_requestId].exists, 'request not found');
        RequestStatus memory request = s_requests[_requestId];
        correctNum = request.randomWords;
         newNum = correctNum[0] % 10;
        return (request.fulfilled, request.randomWords);
    }
    function getCorrectNumber () public onlyOwner view returns  (uint256){
        return newNum;
    }
}
