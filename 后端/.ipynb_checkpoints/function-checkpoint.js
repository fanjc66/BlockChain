const path = require('path');
const Configuration = require('../nodejs-sdk/packages/api/common/configuration').Configuration;
Configuration.setConfig(path.join(__dirname,"core.json"));

const Web3jService = require('../nodejs-sdk/packages/api').Web3jService;
let web3jService = new Web3jService();

//智能合约地址
var constractAddr = "0xca2f113a904c55a878b7bd984503b68be8ef41c6";
//账号对应的信息
var record = {
    "1":{"password":"123","config":"core.json"},
    "2":{"password":"123","config":"supply.json"},
    "3":{"password":"123","config":"thirdparty.json"}
};

//登录验证
function check(account,password)
{
    return password == record[account]["password"];
}
//返回信息(登录时必须先按序调用)
async function getRecord(account)
{
    Configuration.setConfig(path.join(__dirname,record[account]["config"]));
    web3jService.resetConfig();
    //return web3jService.call(constractAddr,"getRecord");
    return new Promise((resolve) => {
        result = await web3jService.call(constractAddr,"getRecord",[]);
        resolve(result["output"]);
        }
    );
}
async function getBalance()
{
    return web3jService.call(constractAddr,"getBalance");
}
//call(合约地址，函数名，参数列表)
async function createVoucher(name,amount,goods)
{
    //true or false
    return new Promise((resolve) => {
        result = await web3jService.call(constractAddr,"createVoucher",[name,amount,goods]);
        resolve(result["output"]);
        }
    );
}

async function transferVoucher(name,amount,goods)
{
    //true or false
    return new Promise((resolve) => {
        result = await web3jService.call(constractAddr,"transferVoucher",[name,amount,goods]);
        resolve(result["output"]);
        }
    );
}
async function financingByVoucher(name,amount)
{
    //true or false
    return new Promise((resolve) => {
        result = await web3jService.call(constractAddr,"financingByVoucher",[name,amount]);
        resolve(result["output"]);
        }
    );
}
async function payVoucher(name)
{
    //true or false
    return new Promise((resolve) => {
        result = await web3jService.call(constractAddr,"payVoucher",[name]);
        resolve(result["output"]);
        }
    );
}
