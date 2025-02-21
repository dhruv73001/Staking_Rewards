pragma solidity ^0.8.0;

contract StakingContract {
    mapping(address => uint256) public stakes;
    mapping(address => uint256) public rewards;
    mapping(address => uint256) public lastUpdate;
    uint256 public rewardRate = 1;
    uint256 public totalStaked;

    function stake() public payable {
        updateReward(msg.sender);
        stakes[msg.sender] += msg.value;
        totalStaked += msg.value;
    }

    function withdraw() public {
        updateReward(msg.sender);
        uint256 amount = stakes[msg.sender];
        require(amount > 0, "No funds to withdraw");
        stakes[msg.sender] = 0;
        totalStaked -= amount;
        payable(msg.sender).transfer(amount);
    }

    function claimReward() public {
        updateReward(msg.sender);
        uint256 reward = rewards[msg.sender];
        require(reward > 0, "No rewards available");
        rewards[msg.sender] = 0;
        payable(msg.sender).transfer(reward);
    }

    function updateReward(address user) internal {
        uint256 timeElapsed = block.timestamp - lastUpdate[user];
        rewards[user] += stakes[user] * rewardRate * timeElapsed / 1 days;
        lastUpdate[user] = block.timestamp;
    }
}
