pragma solidity ^0.4.11;
// We have to specify what version of compiler this code will compile with

contract Voting {
    /* mapping field below is equivalent to an associative array or hash.
    The key of the mapping is candidate name stored as type bytes32 and value is
    an unsigned integer to store the vote count
    */
    mapping (bytes32 => uint8) public votesReceived;
    mapping (address => bool) public accountList;
  
    /* Solidity doesn't let you pass in an array of strings in the constructor (yet).
    We will use an array of bytes32 instead to store the list of candidates
    */
    bytes32[] public candidateList;

    modifier onlyVoteOnce() {
        require(accountList[msg.sender] == false);
        _;
    }

    function validCandidate(bytes32 candidate) returns (bool) {
        for (uint i = 0; i < candidateList.length; i++) {
            if (candidateList[i] == candidate) {
                return true;
            }
        }   
        return false;
    }

    /* This is the constructor which will be called once when you
    deploy the contract to the blockchain. When we deploy the contract,
    we will pass an array of candidates who will be contesting in the election
    */
    function Voting(bytes32[] candidateNames) {
        candidateList = candidateNames;
    }

    // This function returns the total votes a candidate has received so far
    function totalVotesFor(bytes32 candidate) constant returns (uint8) {
        if (validCandidate(candidate) == false) 
            revert();
        return votesReceived[candidate];
    }

    // This function increments the vote count for the specified candidate. This
    // is equivalent to casting a vote
    function voteForCandidate(bytes32 candidate) onlyVoteOnce {
        if (validCandidate(candidate) == false) 
            revert();
        votesReceived[candidate] += 1;
        accountList[msg.sender] = true;
    }

    function getCandidates() constant returns(bytes32[]) {
        return candidateList;
    }
}