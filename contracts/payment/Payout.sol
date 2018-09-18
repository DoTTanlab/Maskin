pragma solidity ^0.4.24;

import "./PaymentRule.sol";
import './PostingNews.sol';
import '../TraceableToken.sol';


contract Payout is PaymentRule, TraceableToken {
  PostingNews public posting;

  event NewPosting(
    address indexed newPost
  );

  constructor() public {
    /* Do nothing now */
  }

  function mine(uint256 _numCoin, address _beneficiary) internal {
    super.mint(_beneficiary, _numCoin);
  }

  function payForWriter(uint256 _numCoin) internal {
    mine(_numCoin.mul(WriterDividend).div(100), posting.getAuthor());
  }

  function payForBusinessManagement(uint256 _numCoin) internal {

  }

  function payForAllHolders(uint256 _numCoin) internal {
    // uint256 numberOfHolders = getTheNumberOfHolders();
  }

  function payForOutstandingArticle() internal {
    uint256 bonus = posting.getTip();
    if(bonus > 0)
      super.transfer(posting.getAuthor(), bonus);
  }

  function paymentAll() internal {
    uint256 royalty = posting.getStar();
    royalty = royalty.mul(paymentBase);
    if(royalty > 0) {
      payForWriter(royalty);
      payForBusinessManagement(royalty);
      payForAllHolders(royalty);
      payForOutstandingArticle();
    }
  }

  function newPosting(PostingNews _news) public onlyAdmin {
    emit NewPosting(_news);
    posting = _news;
    paymentAll();
  }
}
