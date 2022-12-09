// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IERC20Mintable} from "./Coin.sol";

error InsufficientAllowance();
error InsufficientBalance();

contract StakeCoin {
    IERC20Mintable public immutable stakeCoin;
    IERC20Mintable public immutable rewardCoin;
    mapping(address => uint256) public stakedAmounts;

    constructor(address _stakeCoin, address _rewardCoin) {
        stakeCoin = IERC20Mintable(_stakeCoin);
        rewardCoin = IERC20Mintable(_rewardCoin);
    }

    function stakeToken(uint256 amount) external {
        if (stakeCoin.allowance(msg.sender, address(this)) <= amount) {
            revert InsufficientAllowance();
        }

        stakeCoin.transferFrom(msg.sender, address(this), amount);
        stakedAmounts[msg.sender] = amount;
    }

    function redeemStake(uint256 amount) external {
        if (stakedAmounts[msg.sender] == 0) {
            revert InsufficientBalance();
        }

        uint256 amount = stakedAmounts[msg.sender];
        stakedAmounts[msg.sender] = stakedAmounts[msg.sender] - amount;

        stakeCoin.transfer(msg.sender, amount);
    }
}
