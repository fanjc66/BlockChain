<template>
	<div class="page">
		<img class="icon" src="@/assets/icon/set.png" alt="" @click="setting">
		<div class="banner">
			<img src="@/assets/imgs/downstream-bg.jpg" alt="">
		</div>
		<div class="card">
			<p>企业名称：<span>{{name}}</span></p>
			<p>账户余额：<span>{{balance}}￥</span></p>
		</div>
		
		<div class="box">
			<van-tabs v-model="active">
  				<van-tab title="转让">
	  				<van-form @submit="onTransferSubmit">
						<van-field
							v-model="transfer_target_name"
							required
							label="接收方"
							placeholder="请输入接收方企业名称"
							:rules="[{required:true}]"
						/>
						<van-field
							v-model="transfer_amount"
							type="number"
							required
							label="转让金额"
							placeholder="请输入转让金额（￥）"
							:rules="[{required:true}]"
						/>
						<van-field
							v-model="transfer_goods"
							required
							label="交易货物"
							placeholder="请输入交易货物名称"
							:rules="[{required:true}]"
						/>
						<van-button native-type="submit">转让账单</van-button>
					</van-form>
  				</van-tab>
 				<van-tab title="融资">
					<van-form @submit="onFinancingSubmit">
						<van-field
							v-model="financing_target_name"
							required
							label="接收方"
							placeholder="请输入融资银行名称"
							:rules="[{required:true}]"
						/>
						<van-field
							v-model="financing_amount"
							type="number"
							required
							label="融资金额"
							placeholder="请输入融资金额（￥）"
							:rules="[{required:true}]"
						/>
						<van-button native-type="submit">融资</van-button>
					</van-form>
				</van-tab>
				<van-tab title="结算">
					<van-form @submit="onSettlement">
						<van-field
								v-model="settlement_target"
								required
								label="付款方"
								placeholder="请输入付款方名称"
								:rules="[{required:true}]"
							/>
						<van-button native-type="submit">结算</van-button>
					</van-form>
				</van-tab>
			</van-tabs>
		</div>
	</div>
</template>

<script>
	import { getRecord,getBalance,transferVoucher, financingByVoucher,payVoucher } from '@/lib/API/api'

	export default {
		data () {
			return {
				name:'',
				balance:0,
				active:3,
				transfer_target_name:'',
				transfer_amount: '',
				transfer_goods:'',
				financing_target_name:'',
				financing_amount:'',
				settlement_target:'',
				settlement_count:0,
			}
		},
		created() {
			getRecord()
			getBalance()
		},

		methods: {
			async getRecord(){
				let res = await getRecord(params)
				this.name = res.name
			},
			async getBalance(){
				let res = await getBalance(params)
				this.balance = res
			},
			async transferVoucher(params){
				let params = {
					transfer_target_name:this.transfer_target_name,
					transfer_amount: this.transfer_amount,
					transfer_goods: this.transfer_goods
				}
				let res = await transferVoucher(params)
				if (res === true) {
					this.$toast('账单转让成功')
				} else {
					this.$toast('账单转让失败')
				}
			},
			async financingByVoucher(params){
				let params = {
					financing_target_name:this.financing_target_name,
					financing_amount: this.financing_amount
				}
				let res = await financingByVoucher(params)
				if (res === true) {
					this.$toast('融资成功')
					this.balance += parseInt(this.financing_amount)
				} else {
					this.$toast('融资失败')
				}
			},
			async payVoucher(params){
				let params = {
					settlement_target:this.settlement_target
				}
				let res = await payVoucher(params)
				if (res === true) {
					this.$toast('结算成功')
					this.balance += this.settlement_count
				} else {
					this.$toast('结算失败')
				}
			},
			onTransferSubmit() {
				console.log('transferSubmit');
				this.transferVoucher()
			},
			onFinancingSubmit() {
				console.log('financingSubmit')
				this.financingByVoucher()
			},
			onSettlement() {
				console.log('settlementSubmit')
				this.payVoucher()
			},
			setting() {
				this.$router.push({name:'设置'})
			}
		}
	}
</script>

<style lang="less" scoped>
.page {
	background: #F8F9FB;
	display: flex;
	flex-direction: column;
	align-items: center;;
	.icon{
        height:48px;
		width:50px;
		margin: 40px 0 0 78%;
        z-index: 3;
    }
	.banner {
		width:100%;
		height: 400px;
		overflow: hidden;
		z-index: 1;
		margin-top: -88px;
	}
	.card {
		z-index: 9;
	    margin-top: -180px;
		width:90%;
		height: 300px;
		background:rgba(255,255,255,1);
		box-shadow:0px 8px 10px 0px rgba(0,0,0,0.08);
		border-radius:20px;
		padding: 32px 30px;
		text-align: left;
		>p {
			padding: 26px;
			height: 100px;
			line-height:100px;
			display: flex;
			justify-content: space-between;
			border-bottom: solid #E6E6E6 1px;
			font-family:PingFangSC-Regular;
			font-weight:800;
			color:rgba(51,51,51,1);
			>span {
				font-size: 44px;
				font-weight: 400;
			}
	  	}
	}
	.box {
		width: 662px;
   		background: #eeeeee;
        border-radius: 15px;
        display: flex;
		flex-direction: column;
		align-items: center;
	    margin-top: 40px;
		>.banner {
        text-align: left;
		padding-left: 42px;
		font-size: 30px;
        width: 662px;
        height: 56px;
	    line-height: 56px;
        background: #EBF5FF;
    	}
	}
	/deep/ .van-form {
		width: 100%;
		margin-top: 30px;
	}
	/deep/ .van-cell {
		margin: 5px 0 5px 0;
		line-height: 60px;
		font-size: 30px;
		font-weight: 500;
	}
	/deep/ .van-button {
		width:100%;
		height:88px;
		line-height: 88px;
		background:#999;
		box-shadow:0px 4px 8px 0px #333333;
		border-radius:8px;
		font-size:32px;
		font-family:PingFangSC-Medium,PingFang SC;
		font-weight:500;
		color:#fff;
		margin: 200px 0 15px 0;
		border: none;
	}
	/deep/ .van-tabs {
		margin: 30px auto;
	}
	/deep/ .van-tab {
		font-size: 40px;
		font-weight: 54s0;
		font-family: PingFangSC-Regular;
	}
	/deep/ .van-tabs__line {
		background-color: #0000CD;
		width: 120px;
	}

}
</style>
