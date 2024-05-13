// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract TokenBridge is Pausable {
    mapping(address => bool) public signers;
    mapping(uint256 => bool) public chainId;

    struct FeeDetails {
        uint256 feePercentage;
        uint256 feeRatio;
        uint256 accruedFees;
        address payee;
    }

    FeeDetails public feeDetails;

    struct FeeDiscount {
        IERC20 token;
        uint256 discountedPercentage;
        uint256 balanceRequired;
    }

    FeeDiscount[] public feeDiscounts;

    event Bridge(
        address indexed recipient,
        uint256 amount,
        uint256 fromChain,
        uint256 toChain
    );

    event ReceiveBridge(
        address indexed recipient,
        uint256 amount,
        uint256 fromChain,
        uint256 toChain
    );

    modifier onlySigner() {
        require(signers[msg.sender], "caller is not a signer");
        _;
    }

    constructor(address _signer) {
        signers[_signer] = true;
    }

    function bridge(
        address _recipient,
        uint256 _amount,
        uint256 _toChain
    ) public virtual {
        /*
        require(chainId[_chain], "Chain must be enabled for bridging");

        require(balanceOf(msg.sender) >= _amount, "Not enough token balance");
        _burn(msg.sender, _amount);

        uint256 feePercentage = getFeePercentageForUser(msg.sender);
        uint256 feeRatio = feeDetails.feeRatio;
        uint256 _fee = (_amount * feePercentage) / feeRatio;
        uint256 _amountAfterFee = _amount - _fee;

        feeDetails.accruedFees += _fee;

        emit Bridge(_recipient, _amountAfterFee, block.chainid, _toChain);
        */

        emit Bridge(_recipient, _amount, block.chainid, _toChain);
    }

    function receiveBridge(
        address _recipient,
        uint256 _amount,
        uint256 _fromChain,
        uint256 _toChain
    ) public virtual onlySigner whenNotPaused {
        /*
        _mint(_recipient, _amount);
        emit ReceiveBridge(_recipient, _amount, _fromChain, _toChain);
        */
        emit ReceiveBridge(_recipient, _amount, _fromChain, _toChain);
    }
}
