pragma solidity ^0.4.24;

import './zeppelin/contracts/ownership/Contactable.sol';

import './base-token/PausableToken.sol';
import './delegate/CanDelegateToken.sol';
import './delegate/DelegateToken.sol';
import './AssetInfo.sol';
import './BurnableExToken.sol';
import './WithdrawalToken.sol';
import './payment/Payout.sol';


/**
 * @title Maskin token.
 * @dev MaskinToken is a ERC20 token that:
 *  - caps total number at 100 million tokens.
 *  - can pause and unpause token transfer (and authorization) actions.
 *  - mints new tokens when purchased.
 *  - token holders can be distributed profit from asset manager.
 *  - contains real asset information.
 *  - can delegate to a new contract.
 *  - can enforce burning all tokens.
 *  - transferring tokens to 0x0 address is treated as burning.
 *  - transferring tokens with fees are sent to the system wallet.
 *  - attempts to check KYC/AML and Blacklist using Registry.
 *  - attempts to reject ERC20 token transfers to itself and allows token transfer out.
 *  - attempts to reject ether sent and allows any ether held to be transferred out.
 *  - allows the new owner to accept the ownership transfer, the owner can cancel the transfer if needed.
 **/
contract MaskinToken is Contactable, AssetInfo, Payout, BurnableExToken, CanDelegateToken, DelegateToken, WithdrawalToken, PausableToken {
  string public name = "MaskinCoin";
  string public symbol = "MAS";

  uint8 public constant decimals = 18;
  uint256 public constant TOTAL_TOKENS = 100 * (10**6) * (10 ** uint256(decimals));

  constructor(
    string _fixedDocsLink,
    string _varDocsLink
  )
    public
    AssetInfo(_fixedDocsLink, _varDocsLink)
  {
    contactInformation = 'https://rax.exchange/';
  }

  /**
   * @dev Mints tokens to a beneficiary address.
   * Cap minting so that totalSupply <= TOTAL_TOKENS.
   * @param _to Who got the tokens.
   * @param _amount Amount of tokens.
   */
  function mint(
    address _to,
    uint256 _amount
  )
    public
    hasMintPermission
    canMint
    returns(bool)
  {
    require(totalSupply().add(_amount) <= TOTAL_TOKENS);

    return super.mint(_to, _amount);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a new owner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) onlyOwner public {
    // do not allow self ownership
    require(_newOwner != address(this));
    super.transferOwnership(_newOwner);
  }
}
