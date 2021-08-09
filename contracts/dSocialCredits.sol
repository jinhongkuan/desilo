pragma solidity ^0.8.3; 

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


contract dSocialCredits is ERC1155 {

    address _admin;
    address[] _authorizedTransfer;
    uint _authTransferCount;

    modifier validTransfer(address from, address to) {
        bool hasValidParty = false;
        for (uint i = 0; i < _authTransferCount; i++) {
            if (to == _authorizedTransfer[i] || from == _authorizedTransfer[i]) {
                hasValidParty = true;
                break;
            }
        }
        require(hasValidParty, "Illegal social credit transfer.");
        _;
    }

    constructor(address _adm, address[] memory _auth, uint _count) ERC1155("") {
        _admin = _adm;
        _authorizedTransfer = _auth;
        _authTransferCount = _count;
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public override validTransfer(from, to) {
        _safeTransferFrom(from, to, id, amount, data);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public virtual override validTransfer(from, to) {
        _safeBatchTransferFrom(from, to, ids, amounts, data);
    }

    function burn(
        address account,
        uint256 id,
        uint256 amount
    ) public {
        require(msg.sender == _admin, "Only designated admin can mint.");
        _burn(account, id, amount);
    }

    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public {
        require(msg.sender == _admin, "Only designated admin can mint.");
        _mint(account, id, amount, data);
    }


    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public {
        require(msg.sender == _admin, "Only designated admin can mint.");
        _mintBatch(to, ids, amounts, data);
    }

}