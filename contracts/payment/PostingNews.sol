pragma solidity ^0.4.24;


contract PostingNews {
  address   private  writer;
  string    private  article;
  uint256   private  star;

  constructor(address _writer, string _title, uint8 _rating) public {
    require(_rating <= 10);
    writer      = _writer;
    article     = _title;
    star        = _rating;
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
}
