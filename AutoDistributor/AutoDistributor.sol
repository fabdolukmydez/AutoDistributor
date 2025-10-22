// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title AutoDistributor
/// @notice Distributes ERC20 tokens to recipients if this contract is authorized (has allowance).
interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract AutoDistributor {
    address public owner;
    event Distributed(address indexed token, address indexed to, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    // distribute from 'from' (must have approved this contract)
    function distributeFrom(address token, address from, address[] calldata recipients, uint256[] calldata amounts) external {
        require(msg.sender == owner, "owner");
        require(recipients.length == amounts.length, "len");
        for(uint256 i=0;i<recipients.length;i++){
            require(IERC20(token).transferFrom(from, recipients[i], amounts[i]));
            emit Distributed(token, recipients[i], amounts[i]);
        }
    }
}
