// SPDX-License-Identifier: MIT

/*
██████╗ ███████╗██╗███╗   ██╗███████╗██╗  ██╗    ██████╗ ██████╗  ██████╗ ████████╗ ██████╗  ██████╗ ██████╗ ██╗     
██╔══██╗██╔════╝██║████╗  ██║██╔════╝╚██╗██╔╝    ██╔══██╗██╔══██╗██╔═══██╗╚══██╔══╝██╔═══██╗██╔════╝██╔═══██╗██║     
██║  ██║█████╗  ██║██╔██╗ ██║█████╗   ╚███╔╝     ██████╔╝██████╔╝██║   ██║   ██║   ██║   ██║██║     ██║   ██║██║     
██║  ██║██╔══╝  ██║██║╚██╗██║██╔══╝   ██╔██╗     ██╔═══╝ ██╔══██╗██║   ██║   ██║   ██║   ██║██║     ██║   ██║██║     
██████╔╝██║     ██║██║ ╚████║███████╗██╔╝ ██╗    ██║     ██║  ██║╚██████╔╝   ██║   ╚██████╔╝╚██████╗╚██████╔╝███████╗
╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝  ╚═════╝ ╚═════╝ ╚══════╝

-------------------------------------------- dfinex.ai ------------------------------------------------------------

*/

pragma solidity ^0.8.0;

// Importing necessary OpenZeppelin contracts for security and token handling
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract DFinexAirdrop is Ownable {
    // Using SafeERC20 for safe handling of ERC20 tokens
    using SafeERC20 for IERC20;

    // Maximum number of addresses allowed for airdrop
    uint256 public maxAddresses = 2500;

    // Total amount of tokens sent during the airdrop
    uint256 public tokensSent;

    // Constructor that initializes the contract
    constructor() Ownable(msg.sender) {}

    // Fallback function to accept ETH
    receive() external payable {}

    /**
     * @dev Distributes tokens to multiple addresses.
     * @param _amount The amount of tokens to send to each address.
     * @param _token The address of the ERC20 token contract.
     * @param _addresses An array of addresses to receive the tokens.
     */
    function distributeTokens(
        uint256 _amount,
        address _token,
        address[] memory _addresses
    ) external onlyOwner {
        require(_addresses.length <= maxAddresses, "DROP: Exceeds the maximum number of addresses");

        for (uint256 i = 0; i < _addresses.length; i++) {
            IERC20(_token).safeTransfer(_addresses[i], _amount);
            tokensSent += _amount; // Update total tokens sent
        }
    }
    
    /**
     * @dev Updates the maximum number of addresses allowed for airdrop.
     * @param _newMax The new maximum number of addresses.
     */
    function updateMaxAddresses(uint256 _newMax) external onlyOwner {
        maxAddresses = _newMax;
    }

    /**
     * @dev Allows the owner to withdraw tokens from the contract in case of emergency.
     * @param _token The address of the ERC20 token contract.
     * @param _amount The amount of tokens to withdraw.
     */
    function emergencyWithdraw(address _token, uint256 _amount) external onlyOwner {
        IERC20(_token).safeTransfer(owner(), _amount);
    }

    /**
     * @dev Allows the owner to withdraw ETH from the contract in case of emergency.
     * @param _amount The amount of ETH to withdraw.
     */
    function emergencyWithdrawETH(uint256 _amount) external onlyOwner {
        payable(owner()).transfer(_amount);
    }
    
}
