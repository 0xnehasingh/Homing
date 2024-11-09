
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract HouseformShare is ERC1155, ERC1155Burnable, Ownable {
    struct Metadata {
        string name;
        string description;
        string image;
    }

    string public name = "HouseformShare";
    string public symbol = "HS";

    mapping(uint => Metadata) public idToMetadata;

    constructor() 
        ERC1155("") 
        Ownable(msg.sender) // Initialize Ownable with the deploying address as the owner
    {}

    function setMetadata(
        uint _id,
        string memory _name,
        string memory _description,
        string memory _image
    ) public onlyOwner {
        idToMetadata[_id] = Metadata({
            name: _name,
            description: _description,
            image: _image
        });
    }

    function mint(
        address _account,
        uint256 _id,
        uint256 _amount,
        bytes memory _data
    ) public onlyOwner {
        _mint(_account, _id, _amount, _data);
    }

    function mintBatch(
        address _to,
        uint256[] memory _ids,
        uint256[] memory _amounts,
        bytes memory _data
    ) public onlyOwner {
        _mintBatch(_to, _ids, _amounts, _data);
    }

    function burn(
        address _account,
        uint256 _id,
        uint256 _amount
    ) public override onlyOwner {
        _burn(_account, _id, _amount);
    }

    function burnBatch(
        address _account,
        uint256[] memory _ids,
        uint256[] memory _amounts
    ) public override onlyOwner {
        _burnBatch(_account, _ids, _amounts);
    }

    function uri(uint256 _id) public view override returns (string memory) {
        Metadata memory metadata = idToMetadata[_id];
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            string(
                                abi.encodePacked(
                                    '{ "name": "',
                                    metadata.name,
                                    '", "description": "',
                                    metadata.description,
                                    '", "image": "',
                                    metadata.image,
                                    '"}'
                                )
                            )
                        )
                    )
                )
            );
    }

    function supportsInterface(bytes4 _interfaceId)
        public
        view
        override(ERC1155)
        returns (bool)
    {
        return super.supportsInterface(_interfaceId);
    }
}