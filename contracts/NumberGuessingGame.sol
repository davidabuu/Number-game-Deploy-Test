// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.7;
error NumberGuessingGame__NotEnoughEthEntered();
error NumberGuessingGame__YOU_FAILED_TRY_AGAIN(); 
import '@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol';
import '@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol';

contract NumberGuessingGame is VRFConsumerBaseV2 {
    //State variables
    address private s_manager;
    uint256 public s_entranceFee = 0.01 ether;
    address [] public players;
    uint256 private correctNumber;
    address public s_recentWinner;
    mapping(address => bool) public paid;
    //VRF Variables
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint16 private constant REQUEST_CONFRIMATIONS = 3;
    uint32 private s_callbackGasLimit = 2;
    uint32 private constant NUM_WORDS = 1;
    constructor(address vrfCoordinatorV2, bytes32 gasLane, uint64 subscriptionId ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        s_manager = msg.sender;
    }
    //Modifiers
    modifier onlyManager {
        require(msg.sender ==  s_manager);
        _;
    }
    function setTheNumber() public onlyManager {
  uint256 requestId = i_vrfCoordinator.requestRandomWords(
      i_gasLane,
      i_subscriptionId,
      REQUEST_CONFRIMATIONS,
      s_callbackGasLimit,
      NUM_WORDS
    );
    }
    function fulfillRandomWords(  uint256, /*requestId*/ uint256[] memory randomWords)
        internal
        virtual
        override
    {
        uint256 number = randomWords[0] % 10;
        correctNumber = number;
    }
    function enterGame () public payable {
        if(msg.value < s_entranceFee){
            revert NumberGuessingGame__NotEnoughEthEntered();
        }
        paid[msg.sender] = true;
        players.push(msg.sender);
    }
    function guessTheNumber (uint256 guessedNum) public payable {
        require(paid[msg.sender], 'Pls pay to enter the game');
        if(guessedNum == correctNumber){
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
          if(!success){
            revert NumberGuessingGame__YOU_FAILED_TRY_AGAIN();
          }else{
            s_recentWinner = msg.sender;
            players = new address payable[](0);

          }
        }


    }
    //Getter Function
    function getAllPlayersLength () public view returns(uint256){
        return players.length;
    }
    function getRecentWinner() public view returns(address){
        return s_recentWinner;
    }
    function getTheCorrectNumber () public onlyManager view returns(uint256){
        return correctNumber;
    }
}
