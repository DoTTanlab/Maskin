pragma solidity ^0.4.24;

import "../zeppelin/contracts/ownership/Ownable.sol";


contract PaymentRule is Ownable {
  uint256 public paymentBase;
  uint8   public WriterDividend;
  uint8   public BusinessDividend;
  uint8   public HolderDividend;

  constructor() public {
    paymentBase       = 1000;
    BusinessDividend  = 10;
    HolderDividend    = 20;
    WriterDividend    = 70;
  }

  function changePaymentBase(uint256 _base) public onlyOwner {
    paymentBase = _base;
  }

  function changeWriterDividend(uint8 _percentage) public onlyOwner {
    require(_percentage <= 100);
    WriterDividend = _percentage;
  }

  function changeBusinessDividend(uint8 _percentage) public onlyOwner {
    require(_percentage <= 100);
    BusinessDividend = _percentage;
  }

  function changeHolderDividend(uint8 _percentage) public onlyOwner {
    require(_percentage <= 100);
    HolderDividend = _percentage;
  }
}
