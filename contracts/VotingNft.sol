// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
error NumberGuessingGame__NotEnoughEthEntered();
error NumberGuessingGame__YOU_FAILED_TRY_AGAIN(); 
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";


contract NumberGuessingGame is VRFConsumerBaseV2, ConfirmedOwner {
      //State variables
    address private s_manager;
    uint256 public s_entranceFee = 0.01 ether;
    address [] public players;
    uint256 private correctNumber;
    address public s_recentWinner;
    mapping(address => bool) public paid;
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);
      //Modifiers
    modifier onlyManager {
        require(msg.sender ==  s_manager);
        _;
    }
    struct RequestStatus {
        bool fulfilled; // whether the request has been successfully fulfilled
        bool exists; // whether a requestId exists
        uint256[] randomWords;
    }
    mapping(uint256 => RequestStatus) public s_requests; /* requestId --> requestStatus */
    VRFCoordinatorV2Interface COORDINATOR;

    // Your subscription ID.
    uint64 s_subscriptionId;
    // past requests Id.
    uint256[] public requestIds;
    uint256 public lastRequestId;
    uint256 [] public correctNum;
    uint256 public newNum;

    // The gas lane to use, which specifies the maximum gas price to bump to.
    // For a list of available gas lanes on each network,
    // see https://docs.chain.link/docs/vrf/v2/subscription/supported-networks/#configurations
    bytes32 keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;

    // Depends on the number of requested values that you want sent to the
    // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
    // so 100,000 is a safe default for this example contract. Test and adjust
    // this limit based on the network that you select, the size of the request,
    // and the processing of the callback request in the fulfillRandomWords()
    // function.
    uint32 callbackGasLimit = 100000;

    // The default is 3, but you can set this higher.
    uint16 requestConfirmations = 3;

    // For this example, retrieve 2 random values in one request.
    // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
    uint32 numWords = 2;

    /**
     * HARDCODED FOR GOERLI
     * COORDINATOR: 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D
     */
    constructor(uint64 subscriptionId)
        VRFConsumerBaseV2(0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D)
        ConfirmedOwner(msg.sender)
    {
        COORDINATOR = VRFCoordinatorV2Interface(0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D);
        s_subscriptionId = subscriptionId;
    }

    // Assumes the subscription is funded sufficiently.
    function requestRandomWords() external onlyManager returns (uint256 requestId) {
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
        require(s_requests[_requestId].exists, "request not found");
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
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
        require(s_requests[_requestId].exists, "request not found");
        RequestStatus memory request = s_requests[_requestId];
        correctNum = request.randomWords;
         newNum = correctNum[0] % 10;
        return (request.fulfilled, request.randomWords);
    }
   
      //Getter Functions
    function getAllPlayersLength () public view returns(uint256){
        return players.length;
    }
    function getRecentWinner() public view returns(address){
        return s_recentWinner;
    }
    function getCorrectNumber () public onlyManager view returns  (uint256){
        return newNum;
    }
}
