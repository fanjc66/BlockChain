pragma solidity >=0.4.25 <=0.7.0;

contract SupplyChainFinance
{
    struct voucher 
    {
        //债权方
        bytes32 creditor;
        //债务方
        bytes32 debtor;
        //交易金额
        int amount;
        //交易货物
        bytes32 goods;
        //有效性
        bool valid;
    } 
    struct record
    {
        //kind表示类型，1为核心企业，2为供应链企业，3为第三方可信机构
        int kind;
        //公司或机构名称
        bytes32 name;
        //记录是否有效
        bool valid;
    }
    //账单列表
    voucher[] private _voucherList;
    //名称到账户的映射
    mapping( bytes32 => int ) private _balances;
    //哈希地址到信息的映射
    mapping( address => record ) private _enterprises;
    //名称到哈希地址的映射
    mapping(bytes32 => address) private _hashAddress;
    //管理员哈希地址
    address private _administrator;
    
    constructor() public
    {
        _administrator = msg.sender;
    }
    //事件
    event createEnterpriseEvent(address addr,bytes32 name,int kind,bytes32 message);
    event removeEnterpriseEvent(address addr,bytes32 message);
    event setBalanceEvent(address addr,int balance,bytes32 message);
    event createVoucherEvent(bytes32 creditor,bytes32 debtor,int amount,bytes32 goods,bytes32 message);
    event transferVoucherEvent(bytes32 creditor,bytes32 debtor,int amount,bytes32 goods,bytes32 message);
    event financingByVoucherEvent(bytes32 creditor,bytes32 debtor,int amount,bytes32 message);
    event payVoucherEvent(bytes32 creditor,bytes32 debtor,int pays,bytes32 message);
    //修饰器
    modifier isAdministrator
    {
        require(_administrator==msg.sender,"Auth: administrator required");
        _;
    }
    modifier isCoreEnterprises
    {
        require(_enterprises[msg.sender].valid&&_enterprises[msg.sender].kind==1,"Auth: core enterprises required");
        _;
    }
    modifier isSupplyEnterprises
    {
        require(_enterprises[msg.sender].valid&&_enterprises[msg.sender].kind==2,"Auth: supply enterprises required");
        _;
    }
    modifier isThirdParties
    {
        require(_enterprises[msg.sender].valid&&_enterprises[msg.sender].kind==3,"Auth: third parties required");
        _;
    }
    
    //获取节点对应的公司或机构名与类型
    function getRecord() public view returns(bytes32,int)
    {
        require(_administrator!=msg.sender,"Auth: administrator does not have a enterprise");
        require(_enterprises[msg.sender].valid,"Auth: this address did not create a enterprise");
        return (_enterprises[msg.sender].name,_enterprises[msg.sender].kind);
    }
    //获取节点对应的公司或机构的余额
    function getBalance() public view returns(int)
    {
        require(_administrator!=msg.sender,"Auth: administrator does not have a enterprise");
        require(_enterprises[msg.sender].valid,"Auth: this address did not create a enterprise");
        return _balances[_enterprises[msg.sender].name];
    }
    //添加新的企业或机构
    
    function create(address addr,bytes32 name,int kind) public isAdministrator returns(bool)
    {
        //一个节点只能占据一个企业或机构
        require(!_enterprises[addr].valid,"The address is occupied!");
        _enterprises[addr].kind = kind;
        _enterprises[addr].name = name;
        _enterprises[addr].valid = true;
        _balances[name] = 0;
        _hashAddress[name] = addr;
        emit createEnterpriseEvent(addr,name,kind,"Enterprise Created!");
        return true;
    }
    //删除地址对应的企业或机构
    
    function remove(address addr) public isAdministrator returns(bool)
    {
        require(_enterprises[addr].valid,"The address represents no enterprises");
        _enterprises[addr].valid = false;
        emit removeEnterpriseEvent(addr,"Node's Enterprise Removed!");
        return true;
    }
    //给特定账户设置余额
    
    function setBalance(address addr,int balance) public isAdministrator returns(bool)
    {
        require(_enterprises[addr].valid,"The address represents no enterprises");
        _balances[_enterprises[addr].name] = balance;
        emit setBalanceEvent(addr,balance,"Set Balance");
        return true;
    }
    //功能一
    
    function createVoucher(bytes32 creditor,int amount,bytes32 goods) public isCoreEnterprises returns(bool)
    {
        require(_enterprises[msg.sender].name != creditor,"Creditor and Debtor can't be the same!");
        require(_enterprises[_hashAddress[creditor]].valid,"Invalid Creditor!");
        require(_enterprises[_hashAddress[creditor]].kind == 2,"Creditor has to be a SupplyEnterprise");
        _voucherList.push(voucher({creditor:creditor,
                                    debtor:_enterprises[msg.sender].name,
                                    amount:amount,
                                    goods:goods,
                                    valid:true}));
        emit createVoucherEvent(creditor,_enterprises[msg.sender].name,amount,goods,"Core-Supply Transaction");
        return true;
    }
    //功能二
    
    function transferVoucher(bytes32 receiver,int amount,bytes32 goods) isSupplyEnterprises public returns(bool)
    {
        require(_enterprises[_hashAddress[receiver]].valid,"The receiver doesn't exist!");
        require(_enterprises[_hashAddress[receiver]].kind == 2,"The receiver has to be a SupplyEnterprise!");
        int sum = 0;
        bool success = false;
        for(uint i = 0;i < _voucherList.length;i++)
        {
            if(_voucherList[i].valid && _voucherList[i].creditor == _enterprises[msg.sender].name)
            {
                if(_voucherList[i].amount > amount)
                {
                    _voucherList[i].amount -= amount;
                    _voucherList.push(voucher({creditor:receiver,
                                    debtor:_voucherList[i].debtor,
                                    amount:amount,
                                    goods:goods,
                                    valid:true}));
                    success = true;
                }
                else if(_voucherList[i].amount == amount)
                {
                    _voucherList[i].creditor = receiver;
                    success = true;
                }
                else
                {
                    sum += _voucherList[i].amount;
                }
                if(sum >= amount)
                {
                    if(sum > amount)
                    {
                        _voucherList[i].amount = sum - amount;
                    }
                    else
                    {
                        _voucherList[i].valid = false;
                    }
                    for(uint j = i - 1;j >= 0;j--)
                    {
                        if(_voucherList[j].valid && _voucherList[j].creditor == _enterprises[msg.sender].name)
                        {
                            _voucherList[j].valid = false;
                        }
                    }
                    _voucherList.push(voucher({creditor:receiver,
                                    debtor:_voucherList[i].debtor,
                                    amount:amount,
                                    goods:goods,
                                    valid:true}));
                    success = true;
                }
            }
        }
        if(success)
        {
            emit transferVoucherEvent(receiver,_enterprises[msg.sender].name,amount,goods,"Supply-Supply V-Transaction");
        }
        return success;
    }
    //功能三
    
    function financingByVoucher(bytes32 receiver,int amount) isSupplyEnterprises public returns(bool)
    {
        require(_enterprises[_hashAddress[receiver]].valid,"The receiver doesn't exist!");
        require(_enterprises[_hashAddress[receiver]].kind == 3,"The receiver has to be a ThirdParty!");
        require(_enterprises[msg.sender].kind == 2,"Only SupplyEnterprises can finance by voucher!");
        int sum = 0;
        bool success = false;
        for(uint i = 0;i < _voucherList.length;i++)
        {
            if(_voucherList[i].valid && _voucherList[i].creditor == _enterprises[msg.sender].name)
            {
                if(_voucherList[i].amount > amount)
                {
                    _voucherList[i].amount -= amount;
                    _voucherList.push(voucher({creditor:receiver,
                                    debtor:_voucherList[i].debtor,
                                    amount:amount,
                                    goods:"",
                                    valid:true}));
                    _balances[_enterprises[msg.sender].name] += amount;
                    success = true;
                }
                else if(_voucherList[i].amount == amount)
                {
                    _voucherList[i].creditor = receiver;
                    _balances[_enterprises[msg.sender].name] += amount;
                    success = true;
                }
                else
                {
                    sum += _voucherList[i].amount;
                }
                if(sum >= amount)
                {
                    if(sum > amount)
                    {
                        _voucherList[i].amount = sum - amount;
                    }
                    else
                    {
                        _voucherList[i].valid = false;
                    }
                    for(uint j = i - 1;j >= 0;j--)
                    {
                        if(_voucherList[j].valid && _voucherList[j].creditor == _enterprises[msg.sender].name)
                        {
                            _voucherList[j].valid = false;
                        }
                    }
                     _voucherList.push(voucher({creditor:receiver,
                                    debtor:_voucherList[i].debtor,
                                    amount:amount,
                                    goods:"",
                                    valid:true}));
                    _balances[_enterprises[msg.sender].name] += amount;
                    success = true;
                }
            }
        }
        if(success)
        {
            emit financingByVoucherEvent(receiver,_enterprises[msg.sender].name,amount,"Supply-ThirdParty Transaction");
        }
        return success;
    }
    //功能四
    
    function payVoucher(bytes32 debtor) isSupplyEnterprises public returns(int)
    {
        require(_enterprises[_hashAddress[debtor]].kind == 1,"The debtor has to be a CoreEnterprise!");
        require(_enterprises[msg.sender].kind != 1,"CoreEnterprises can't have vouchers!");
        int pays = 0;
        for(uint i = 0;i < _voucherList.length;i++)
        {
            if(_voucherList[i].valid && _voucherList[i].creditor == _enterprises[msg.sender].name && _voucherList[i].debtor == debtor)
            {
                if (_balances[debtor] - pays >= _voucherList[i].amount)
                {
                    pays += _voucherList[i].amount;
                    _voucherList[i].valid = false;
                }
                else
                {
                    int rem = _balances[debtor] - pays;
                    pays += rem;
                    _voucherList[i].amount -= rem;
                    break;
                }
            }
        }
        emit payVoucherEvent(_enterprises[msg.sender].name,debtor,pays,"Voucher-to-cash Transaction");
        _balances[debtor] -= pays;
        _balances[_enterprises[msg.sender].name] += pays;
        return pays;
    }
}