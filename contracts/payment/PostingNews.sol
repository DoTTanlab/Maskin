pragma solidity ^0.4.24;

import "../access/Administrator.sol";


contract PostingNews is Administrator {
  address   internal  writer;
  string    internal  article;
  uint256   internal  star;
  bool      internal  outstanding;
  uint256   internal  tip;

  constructor(address _writer, string _title, uint8 _rating, bool _outstanding) public {
    require(_rating <= 10);
    writer      = _writer;
    article     = _title;
    star        = _rating;
    outstanding = _outstanding;
    tip         = 0;
  }

  function getAuthor() public view returns(address) {
    return writer;
  }

  /*
   * Star should in range from 0 to 10
   */
  function getStar() public view returns(uint256) {
    return star;
  }

  function getTip() public view returns(uint256) {
    return tip;
  }

  function extraPayment(uint256 _bonus) public onlyAdmin returns(uint256) {
    require(star >= 5);
    tip = 0;
    if(outstanding) {
      tip = _bonus;
    }
  }
}
