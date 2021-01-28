<template>
	<div class="page">
		<img class="icon" src="@/assets/icon/set.png" alt="" @click="setting">
		<div class="banner">
			<img src="@/assets/imgs/bank-bg.jpg" alt="">
		</div>
		<div class="card">
			<p>银行名称：<span>{{name}}</span></p>
		</div>
		
		<div class="box">
	  		<van-form @submit="onSubmit">
				<van-field
					v-model="target_name"
						required
						label="付款方"
						placeholder="请输入付款方企业名称"
						:rules="[{required:true}]"
					/>
				<van-button native-type="submit">支付凭证</van-button>
			</van-form>
		</div>
	</div>
</template>

<script>
	import { getRecord, payVoucher } from '@/lib/API/api'

	export default {
		data () {
			return {
				name:'',
				target_name:'',
			}
		},
		created() {
			getRecord()
		},
		methods: {
			async getRecord(){
				let res = await getRecord(params)
				this.name = res.name
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
			onSubmit() {
				console.log('submit')
				this.$toast('凭证支付成功')
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
	align-items: center;
	.banner {
		width:100%;
		height: 340px;
		overflow: hidden;
		z-index: 1;
		margin-top: -88px;
	}
	.icon{
        height:48px;
		width:50px;
		margin: 40px 0 0 78%;
        z-index: 3;
    }
	.card {
		z-index:9;
	    margin-top: -100px;
		width:90%;
		height: 200px;
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
		width:90%;
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
