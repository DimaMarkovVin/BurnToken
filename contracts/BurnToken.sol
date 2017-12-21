pragma solidity ^0.4.18;

import "./ERC20Interface.sol";
import "./SafeMath.sol";

contract BurnToken is ERC20Interface, SafeMath {
	string public constant name = "Burn Dima`s Token";
	string public constant symbol = "BDT";
	uint8 public constant decimals = 0;

	uint256 _totalSupply = 1000000;
	bool isBurned;
	uint256 startTime = 1512086400;

	address public owner;

	mapping (address => uint256) balances;

	mapping (address => mapping (address => uint256)) allowed;

	function BurnToken() public {
		owner = msg.sender;
		balances[owner] = _totalSupply;
	}


	function totalSupply() public constant returns (uint256 totalSupply) {
		totalSupply = _totalSupply;
		return totalSupply;
	}

	function balanceOf(address _owner) public constant returns (uint256 balance) {
		return balances[_owner];
	}

	function transfer(address _to, uint256 _value) returns (bool success) {
		if(balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value >= balances[_to]) { 
			balances[msg.sender] -= _value;
			balances[_to] += _value;
			Transfer(msg.sender, _to, _value);
			return true;
		}
		else {
			return false;
		}
	}

	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
		if(balances[_from] >= _value && balances[_to] + _value >= balances[_to] && allowed[_from][msg.sender] >= _value) { 
			balances[_from] -= _value;
			balances[_to] += _value;
			Transfer(_from, _to, _value);
			return true;
		}
		else {
			return false;
		}
	}

	function approve(address _spender, uint256 _value) returns (bool success) {
		allowed[msg.sender][_spender] = _value;
		Approval(msg.sender, _spender, _value);
		return true;
	}

	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
		return allowed[_owner][_spender];
	}

	function burn(uint _burnedAmount, uint _burnedTime){
    	if(!isBurned && _burnedTime > startTime && balances[msg.sender] >= _burnedAmount){
    		balances[msg.sender] = safeSub(balances[msg.sender], _burnedAmount);
    		_totalSupply = safeSub(_totalSupply, _burnedAmount);
    		isBurned = true;
    		Burned(_burnedAmount);
    	}
    }
	event Transfer(address indexed _from, address indexed _to, uint256 _value);
	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
	event Burned(uint amount);
}