// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.7.0 <0.9.0;

import "forge-std/Test.sol";
import "../src/CurveFi.sol";
import "../interfaces/cinterface.sol";
import {IERC20} from "openzeppelin-contracts/interfaces/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import {IVault} from "balancer-v2-monorepo/pkg/interfaces/contracts/vault/IVault.sol";
import {IFlashLoanRecipient} from "balancer-v2-monorepo/pkg/interfaces/contracts/vault/IFlashLoanRecipient.sol";
interface IBalancerVault {
  function flashLoan(
    address recipient,
    IERC20[] memory tokens,
    uint256[] memory amounts,
    bytes memory userData
  ) external;
}

interface YearnVault {
    function deposit(uint256 amount) external returns (uint);
    function withdraw(uint256 maxShares) external returns (uint);

    function availableDepositLimit() external returns (uint256);
}
contract CounterTest is Test {
    using SafeERC20 for IERC20;

    Curve3Pool public curve;
    SwapRouterInterface public swapRouter;
    UniswapV2Router public v2router;
    IBalancerVault public balancerVault;
    YearnVault public yearnVault;
    IERC20 public usdc;
    IERC20 public usdt;
    IERC20 public dai;
    IERC20 public weth;
    IERC20 public pool3Lp;
    address public testUser;

    function setUp() public {
        testUser = address(this);
        console.log("THIS ADDRESS", address(this));
        vm.startPrank(testUser);
        vm.rollFork(13848982);
        yearnVault = YearnVault(0x5f18C75AbDAe578b483E5F43f12a39cF75b973a9);
        balancerVault = IBalancerVault(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
        pool3Lp = IERC20(0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490);
        curve = Curve3Pool(0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7);
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
        usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
        weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        swapRouter = SwapRouterInterface(payable(0xE592427A0AEce92De3Edee1F18E0157C05861564));
        v2router = UniswapV2Router(payable(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D));
        mintUserTestCoins();
    }

    function mintUserTestCoins() internal {
        dai.approve(address(curve), type(uint256).max);
        usdc.approve(address(curve), type(uint256).max);
        usdt.safeApprove(address(curve), type(uint256).max);

        console.log(usdt.totalSupply());
        vm.deal(address(this), 10000 ether);

        address[] memory path = new address[](2);
        path[0] = address(weth);
        path[1] = address(usdc);

        v2router.swapETHForExactTokens{value: 5000 ether}(12_000_000 * 1e6, path, address(this), type(uint256).max);
        console.log("USDC BALANCE AFTER SWAP: ", usdc.balanceOf(testUser) / 1e6);

        path[1] = address(usdt);
        v2router.swapETHForExactTokens{value: 100 ether}(100_000 * 1e6, path, testUser, type(uint256).max);
        console.log("USDT BALANCE AFTER SWAP: ", usdt.balanceOf(testUser) / 1e6);

        path[1] = address(dai);
        v2router.swapETHForExactTokens{value: 100 ether}(100_000 * 1e18, path, testUser, type(uint256).max);
        console.log("DAI BALANCE AFTER SWAP: ", dai.balanceOf(testUser) / 1e18);

        console.log("ETHER LEFT", address(this).balance / 1e18);
    }

    function testAddLiquidityToCurve() external {
        uint256[3] memory amounts;
        amounts[0] = 3000 * 1e18;
        amounts[1] = 3000 * 1e6;
        amounts[2] = 3000 * 1e6;

        curve.add_liquidity(amounts, 1);
        console.log("LP TOKENS RECEIVED: ", pool3Lp.balanceOf(testUser) / 1e18);
    }

    function testBalancerFlashLoan() external {
        IERC20[] memory tokens = new IERC20[](1);
        tokens[0] = (usdc);

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1_000_000 * 1e6;

        uint256[] memory feeAmounts = new uint256[](1);
        feeAmounts[0] = 0;

        bytes memory userData = "";
        
        balancerVault.flashLoan(address(this), tokens, amounts, userData);
    }

    function testYearn() external {
        console.log("Available deposit", yearnVault.availableDepositLimit());
    }

    function receiveFlashLoan(
        address[] memory tokens,
        uint256[] memory amounts,
        uint256[] memory feeAmounts,
        bytes memory userData
    ) external   {
        console.log("USDC BALANCE AFTER FLASH LOAN ", usdc.balanceOf(address(this)) / 1e6);
        usdc.approve(address(yearnVault), type(uint).max);
        uint lpDepositAmount = yearnVault.deposit(10_000);
        console.log("LP DEPOSIT ", lpDepositAmount);
        uint lpWithdrawAmount = yearnVault.withdraw(lpDepositAmount);
        console.log("LP Withdraw ", lpWithdrawAmount);
        usdc.transfer(address(balancerVault), 1_000_000 * 1e6);
    }

    receive() external payable {

    }
}
