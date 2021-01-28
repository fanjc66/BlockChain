<template>
	<div class="page">
		<img class="icon" src="@/assets/icon/set.png" alt="" @click="setting">
		<div class="banner">
			<img src="@/assets/imgs/banner-bg.jpg" alt="">
		</div>
		<div class="card">
			<p>企业名称：<span>{{name}}</span></p>
			<p>账户余额：<span>{{balance}}￥</span></p>
		</div>
		<div class="box">
			<div class="title">采购商品</div>
			<van-form @submit="onSubmit">
				<van-field
					v-model="target_name"
					required
					label="下游企业"
					placeholder="请输入下游企业名称"
					:rules="[{ required: true}]"
				/>
				<van-field
					v-model="amount"
					type="number"
					required
					label="交易金额"
					placeholder="请输入交易金额（￥）"
					:rules="[{ required: true}]"
				/>
				<van-field
					v-model="goods"
					required
					label="交易货物"
					placeholder="请输入交易货物名称"
					:rules="[{ required: true}]"
				/>
				<van-button native-type="submit">生成票券</van-button>
			</van-form>
		</div>
    
	</div>
</template>

<script>
	import { getRecord,getBalance,createVoucher, } from '@/lib/API/api'
	import {Toast } from 'vant';
	export default {
		components:{
				Toast,
			},
		data () {
			return {
				name:'',
				balance:'',
				target_name:'',
				amount:'',
				goods:''
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
			async createVoucher(params){
				let params = {
					target_name:this.target_name,
					amount: this.amount,
					goods: this.goods
				}
				let res = await createVoucher(params)
				if (res === true) {
					this.$toast('已成功生成票券');
				} else {
					this.$toast('生成票券失败')
				}
			},
			onSubmit() {
				console.log('submit')
				this.createVoucher()
				this.getBalance()
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
			padding: 32px;
			height: 100px;
			line-height:100px;
			display: flex;
			justify-content: space-between;
			border-bottom: solid #E6E6E6 1px;
			font-family:PingFangSC-Regular;
			font-weight:800;
			color:rgba(51,51,51,1);
			>span {
				display: block;
				font-size: 44px;
				font-weight: 400;
				text-align: center;
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
		>.title {
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
		width: 90%;
		margin-top: 30px;
	}
	/deep/ .van-cell {
		margin: 5px 0 5px 0;
		line-height: 60px;
		font-size: 30px;
		font-weight: 500;
	}
	/deep/ .van-button {
		width: 100%;
		height:88px;
		line-height: 88px;
		background:#999;
		box-shadow:0px 4px 8px 0px #333333;
		border-radius:8px;
		font-size:32px;
		font-family:PingFangSC-Medium,PingFang SC;
		font-weight:500;
		color:#fff;
		margin: 250px 0 50px 0;
		border: none;
	}

}
</style>
