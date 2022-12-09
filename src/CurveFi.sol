// // SPDX-License-Identifier: UNLICENSED
// pragma solidity ^0.8.13;

// import "../interfaces/curvi-fi-interfaces.sol";

// contract CurveFi {

//     address public immutable curve;

//     constructor() {
//         curve = ICurveFi_DepositY(0xA79828DF1850E8a3A3064576f380D90aECDD3359);
//     }

//     function addLiquid() public {
//         address[4] memory stablecoins = ICurveFi_DepositY(curveFi_Deposit).underlying_coins();

//         for (uint256 i = 0; i < stablecoins.length; i++) {
//             IERC20(stablecoins[i]).safeTransferFrom(_msgSender(), address(this), _amounts[i]);
//             IERC20(stablecoins[i]).safeApprove(curveFi_Deposit, _amounts[i]);
//         }

//         //Step 1 - deposit stablecoins and get Curve.Fi LP tokens
//         ICurveFi_DepositY(curveFi_Deposit).add_liquidity(_amounts, 0); //0 to mint all Curve has to

//         //Step 2 - stake Curve LP tokens into Gauge and get CRV rewards
//         // uint256 curveLPBalance = IERC20(curveFi_LPToken).balanceOf(address(this));

//         // IERC20(curveFi_LPToken).safeApprove(curveFi_LPGauge, curveLPBalance);
//         // ICurveFi_Gauge(curveFi_LPGauge).deposit(curveLPBalance);

//         // //Step 3 - get all the rewards (and make whatever you need with them)
//         // crvTokenClaim();
//         // uint256 crvAmount = IERC20(curveFi_CRVToken).balanceOf(address(this));
//         // IERC20(curveFi_CRVToken).safeTransfer(_msgSender(), crvAmount);
//     }

// }
