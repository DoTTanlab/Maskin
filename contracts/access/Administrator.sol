pragma solidity ^0.4.24;

import "../zeppelin/contracts/ownership/Ownable.sol";
import "../zeppelin/contracts/access/rbac/RBAC.sol";


contract Administrator is Ownable, RBAC {
  string public constant ROLE_ADMIN = "Admin";

  /**
   * @dev Throws if called by any account that is not in the Admin list.
   */
  modifier onlyAdmin() {
    require(hasRole(msg.sender, ROLE_ADMIN));
    _;
  }

  /**
   * @dev Throws if operator is not Admin
   * @param _operator address
   */
  modifier onlyIfAdmin(address _operator) {
    checkRole(_operator, ROLE_ADMIN);
    _;
  }

  /**
   * @dev add an address to the Admin list
   * @param _operator address
   * @return true if the address was added to the Admin list, false if the address was already in the Admin list
   */
  function addToAdminList(address _operator)
    public
    onlyOwner
  {
    addRole(_operator, ROLE_ADMIN);
  }

  /**
   * @dev getter to determine if address is in Admin list
   */
  function admin(address _operator)
    public
    view
    returns (bool)
  {
    return hasRole(_operator, ROLE_ADMIN);
  }

  /**
   * @dev add addresses to the Admin list
   * @param _operators addresses
   * @return true if at least one address was added to the Admin list,
   * false if all addresses were already in the Admin list
   */
  function addSomeToAdminlist(address[] _operators)
    public
    onlyOwner
  {
    for (uint256 i = 0; i < _operators.length; i++) {
      addToAdminList(_operators[i]);
    }
  }

  /**
   * @dev remove an address from the Admin list
   * @param _operator address
   * @return true if the address was removed from the Admin list,
   * false if the address wasn't in the Admin list in the first place
   */
  function removeFromAdminList(address _operator)
    public
    onlyOwner
  {
    removeRole(_operator, ROLE_ADMIN);
  }

  /**
   * @dev remove addresses from the Admin list
   * @param _operators addresses
   * @return true if at least one address was removed from the Admin list,
   * false if all addresses weren't in the Admin list in the first place
   */
  function removeSomeFromAdminList(address[] _operators)
    public
    onlyOwner
  {
    for (uint256 i = 0; i < _operators.length; i++) {
      removeFromAdminList(_operators[i]);
    }
  }

}
