// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "forge-std/Test.sol";
// import "../src/Stake.sol";
// import "../src/RewardCoin.sol";

// contract CounterTest is Test {
//     StakeCoin public staker;
//     RewardCoin public rewardToken;

//     function setUp() public {
//         rewardToken = new RewardCoin();
//         rewardToken.mint(msg.sender, 1000);
//         address[3] memory initialUsers = [address(0x7), address(0x8), address(0x9)];
//         staker = new StakeCoin(address(rewardToken), initialUsers);
//     }

//     function testBalanceCall() external view {
//         (uint256 balance1, uint256 balance2) = staker.getBalances();
//         console.log(balance1, balance2);
//     }

//     function testStakeCoin() external {
//         vm.startPrank(address(0x7));
//         staker.approve(address(staker), type(uint256).max);
//         // console.log(staker.balanceOf(address(0x7)));
//         staker.stakeCoin(100);
//         assertEq(staker.balanceOf(address(staker)), 100);

//         vm.roll(block.number + 100);
//         uint reward = staker.getReward();
//         console.log("reward is ", reward);
//     }
// }
