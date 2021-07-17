// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
pragma experimental ABIEncoderV2;

/**
 * @title Sequencer
 * @dev Store & retrieve value in a variable
 */
contract BeatBox {
    
    struct User {
        address wallet;
        uint id;
        string username;
        bytes32[] sequences;
    }
    mapping (address => User) userMap;
    address[] userIndex;
    
    struct Sequence {
        bytes32 id;
        address owner;
        string name;
        bytes32[] modules;
        uint createdAt;
        uint updatedAt;
    }
    mapping (bytes32 => Sequence) sequenceMap;
    bytes32[] sequenceIndex;
    
    struct Module {
        bytes32 id;
        string instrument;
        bool beat_1;
        bool beat_2;
        bool beat_3;
        bool beat_4;
        uint createdAt;
        uint updatedAt;
    }
    mapping (bytes32 => Module) moduleMap;
    bytes32[] moduleIndex;
    
    address payable _devAddress;
    
    constructor() {
        _devAddress = payable(msg.sender);
        userMap[msg.sender] = User({
            wallet: msg.sender,
            id: userIndex.length,
            username: 'developer',
            sequences: new bytes32[](0) 
        });
        userIndex.push(msg.sender);
    }  
    
    function getSequenceModules(bytes32 _sequenceId) public view returns (Module[] memory) {
        Sequence memory _sequence = sequenceMap[_sequenceId];
        Module[] memory _modules = new Module[](_sequence.modules.length);
        for(uint i = 0; i < _sequence.modules.length; i++) {
            _modules[i] = moduleMap[_sequence.modules[i]];
        }
        return _modules;
    }
    
    function createUser(string memory _username) public {
        User memory newUser = User({
            wallet: msg.sender,
            id: userIndex.length,
            username: _username,
            sequences: new bytes32[](0)
        });
        userMap[msg.sender] = newUser;
        userIndex.push(msg.sender);
    }
    
    function updateUser(string memory _username) public {
        User storage _user = userMap[msg.sender];
        _user.username = _username;
    }
    
    function getUsers() public view returns (User[] memory) {
        User[] memory _users = new User[](userIndex.length);
        for (uint i = 0; i < userIndex.length; i++) {
            _users[i] = userMap[userIndex[i]];
        }
        return _users;
    }
    
    function createSequence(string memory _name) public {
        User storage _user = userMap[msg.sender];
        bytes32 sequenceId = keccak256(abi.encodePacked(msg.sender, block.timestamp, _name));
        sequenceMap[sequenceId] = Sequence({
            id: sequenceId,
            owner: _user.wallet,
            name: _name,
            createdAt: block.timestamp,
            updatedAt: block.timestamp,
            modules: new bytes32[](0)
        });
        sequenceIndex.push(sequenceId);
        _user.sequences.push(sequenceId);
    }
    
    function getAllSequences() public view returns (Sequence[] memory) {
        Sequence[] memory _sequences = new Sequence[](sequenceIndex.length);
        for (uint i = 0; i < sequenceIndex.length; i++) {
            _sequences[i] = sequenceMap[sequenceIndex[i]];
        }
        return _sequences;
    }
    
    function getUserSequences() public view returns (Sequence[] memory) {
        User memory _user = userMap[msg.sender];
        Sequence[] memory _sequences = new Sequence[](_user.sequences.length);
        for (uint i =0; i < _user.sequences.length; i++) {
            _sequences[i] = sequenceMap[_user.sequences[i]];
        }
        return _sequences;
    }
    
    function buyMeACoffee() public payable {
        uint contribution = msg.value;
        _devAddress.transfer(contribution);
    } 
}