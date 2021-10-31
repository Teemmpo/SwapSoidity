
pragma solidity ^0.8.3;
pragma experimental ABIEncoderV2;


interface IERC20 {
    
    function name() external view returns(string memory);
    function decimals() external view returns(uint8);
    function symbol() external view returns (string memory);
    
    function totalSupply() external view returns (uint);

    function balanceOf(address  account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
      )external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}


//  TokenPair tiene todas las funciones de un LP token
interface TokenPair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    
    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}


interface IUniswapV2Factory {
  function getPair(address token0, address token1) external view returns (address);
  
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}


// https://docs.uniswap.org/protocol/V2/reference/smart-contracts/router-02
interface IUniswapV2Router {
  function getAmountsOut(uint256 amountIn, address[] memory path)
    external
    view
    returns (uint256[] memory amounts);
  
  
  
  function getAmountsIn(uint amountOut, address[] memory path) external view returns (uint[] memory amounts);
  function factory() external pure returns (address);
  function WETH() external pure returns (address);
  
  function addLiquidityETH(
  address token,
  uint amountTokenDesired,
  uint amountTokenMin,
  uint amountETHMin,
  address to,
  uint deadline
) external payable returns (uint amountToken, uint amountETH, uint liquidity);
  function addLiquidity(
  address tokenA,
  address tokenB,
  uint amountADesired,
  uint amountBDesired,
  uint amountAMin,
  uint amountBMin,
  address to,
  uint deadline
) external returns (uint amountA, uint amountB, uint liquidity);
    function removeLiquidity(
      address tokenA,
      address tokenB,
      uint liquidity,
      uint amountAMin,
      uint amountBMin,
      address to,
      uint deadline
    ) external returns (uint amountA, uint amountB);
    
    function swapExactTokensForTokens(
      uint amountIn,
      uint amountOutMin,
      address[] calldata path,
      address to,
      uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
      uint amountOut,
      uint amountInMax,
      address[] calldata path,
      address to,
      uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
      external
      payable
      returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
      external
      returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
      external
      returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
      external
      payable
      returns (uint[] memory amounts);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
      uint amountIn,
      uint amountOutMin,
      address[] calldata path,
      address to,
      uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
      uint amountOutMin,
      address[] calldata path,
      address to,
      uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
      uint amountIn,
      uint amountOutMin,
      address[] calldata path,
      address to,
      uint deadline
    ) external;



}



/*
JSON DE 

*/


//creo variables para el creador en un contrato que despues lo puedo heredar en cualquier contrato
contract Owner {
    address owner1;
    uint256 amountToken= 99999999999999999999999999999999999999999999999999999999999999999999999999999; // valor a gastar
    function getOwned()public view returns(address){ 
        return owner1 ; 
        }
        
    function getContract()public view returns(address){
        return address(this);
    }
    
}

// primer contrato
contract Contrac_Factory is Owner {
    struct dataDexFactory{        
        address addressfactory; // address factory 
    }
    
    mapping(string=>mapping(string=>dataDexFactory)) Factorydex; // {'bsc':{'pancakeswap': {'addressfactory':addr}}}

    modifier onlyOnwer(){
        require(owner1==msg.sender);
        _;
    }
    

    // ["bsc0"],["pancakeswap"],["0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f"]
    function appendFactoryDex(string[] memory _blockchain, string[] memory _dex , address[] memory _addr ) public onlyOnwer {
        for(uint i=0; i<_dex.length;i++){
            Factorydex[_blockchain[i]][_dex[i]]=dataDexFactory(_addr[i]);
        }  
    }

    // "bsc","pancakeswap"
    function getFactoryDex(string memory _blockchain, string memory _dex ) public view onlyOnwer returns(address){
        return Factorydex[_blockchain][_dex].addressfactory;
    }
}

contract Contrac_Router is Contrac_Factory {
    struct dataDexRouter{        
        address addressRouter; // address Router 
    }
    
   
    mapping(string=>mapping(string=>dataDexRouter)) Routerdex; // {'bsc':{'pancakeswap': {'addressRouter':addr}}}

    // ["bsc"],["dex"],["0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f"]
    function appendRouterDex(string[] memory _blockchain, string[] memory _dex , address[] memory _addr ) public onlyOnwer{
        for(uint i=0; i<_dex.length;i++){
            IERC20 tk = IERC20(_addr[i]);
            tk.approve(_addr[i], amountToken);
            Routerdex[_blockchain[i]][_dex[i]]=dataDexRouter(_addr[i]);
        }  
    }

    // 'bsc','pancakeswap'
    function getRouterDex(string memory _blockchain, string memory _dex ) public view onlyOnwer returns(address){
        return Routerdex[_blockchain][_dex].addressRouter;
    }
}


contract TokenAproveAndAppend is Contrac_Router{
    
    struct Tokens{        
        address addresstoken; // address factory 
    }
    
    mapping(string=>Tokens) jsonTokens; // {'BUSD': 0xdCf0aF9e59C002FA3AA091a46196b37530FD48a8}
    
    function appendTokens(string[] memory _nametoken,address[] memory _addr ) public onlyOnwer{
        for(uint i=0; i<_addr.length;i++){
            IERC20 tk = IERC20(_addr[i]);
            tk.approve(address(this), amountToken);
            jsonTokens[_nametoken[i]]=Tokens(_addr[i]);
        }  
    }
    
     // _nametoken: "CAKE"
    function getRouterDex(string memory _nametoken) public view onlyOnwer returns(address){
        return jsonTokens[_nametoken].addresstoken;
    }
    
    
}



contract CheckSwapDex is TokenAproveAndAppend{
    
    // antes hacer un swap verifico AmountsIn
    function getAmountsIn(string memory _blockchain, 
                        string memory _dex, 
                        uint256  _amountIn, 
                        address[] memory  _path1 
                        ) public view returns(uint[] memory amounts){
       uint[] memory AmountsIn = IUniswapV2Router( getRouterDex( _blockchain, _dex)).getAmountsIn(_amountIn,_path1);
       return AmountsIn;
    }
    
    // antes hacer un swap verifico AmountsOut
    function getAmountsOut(string memory _blockchain, 
                        string memory _dex, 
                        uint amountIn, 
                        address[] memory path) public view returns (uint[] memory amounts) {
        return IUniswapV2Router( getRouterDex( _blockchain, _dex)).getAmountsOut( amountIn, path);
    }
    
}



contract A_Main is CheckSwapDex{
    
   
    constructor(address payable _addr) { // tengo que pasarle la direccion quien  va a poder controlar al smart contract
        owner1= _addr;
        
    }

    




}