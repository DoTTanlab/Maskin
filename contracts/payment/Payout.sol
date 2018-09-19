pragma solidity ^0.4.24;

import "./PaymentRule.sol";
import './PostingNews.sol';
import '../TraceableToken.sol';


contract Payout is PaymentRule, TraceableToken {
  PostingNews public posting;

  event NewPosting(address indexed newPost);

  constructor() public {
    // Do nothing now
  }

  function mine(
    uint256 _numCoin,
    address _beneficiary
  )
    internal
    returns (bool)
  {
    super.mint(_beneficiary, _numCoin);

    emit Mint(_beneficiary, _numCoin);
    return true;
  }

  function payForWriter(uint256 _numCoin) internal returns (bool) {
    mine(_numCoin.mul(WriterDividend).div(100), posting.getAuthor());
    return true;
  }

  function payForBusinessManagement(uint256 _numCoin) internal returns (bool) {
    mine(_numCoin.mul(BusinessDividend).div(100), owner);
    return true;
  }

  function payForAllHolders(uint256 _numCoin) internal returns (bool) {
    uint256 numberOfHolders = getTheNumberOfHolders();
    uint256 pay = _numCoin.mul(HolderDividend).div(100).div(numberOfHolders);
    for(uint256 i = 0; i < numberOfHolders; i++) {
      mine(pay, getHolder(i));
    }
    return true;
  }

  function payForOutstandingArticle(uint256 bonus) public onlyAdmin returns (bool) {
    super.transfer(posting.getAuthor(), bonus);
    return true;
  }

  function paymentAll() internal returns (bool) {
    uint256 royalty = posting.getStar();
    royalty = royalty.mul(paymentBase);
    if(royalty > 0) {
      payForWriter(royalty);
      payForBusinessManagement(royalty);
      payForAllHolders(royalty);
    }
    return true;
  }

  function newPosting(PostingNews _news) public onlyOwner returns (bool) {
    emit NewPosting(_news);
    posting = _news;
    paymentAll();
    return true;
  }
}
