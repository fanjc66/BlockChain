<template>
	<div class="page" >
		<div class="logo">
			<img src="@/assets/icon/logo.png" alt=""> 
			<p>供应链金融平台</p>
		</div>
		<div class="box">
			<van-form @submit="onLogin">
				<van-field
					v-model="ID "
					required
					label="账号"
					placeholder="请输入账号"
				/>
				<van-field
					v-model="password"
					type="password"
					required
					label="密码"
					placeholder="请输入密码"
				/>
				<van-button class="btn"  native-type="submit">登录</van-button>

			</van-form>
		</div>

	</div>
</template>

<script>
	import { Toast } from 'vant';
	import { check } from '@/lib/API/api'

	export default {
		components:{
			Toast,
		},
		data() {
			return {
				ID:'',
				password:'',
				typeList:[
					{name:'核心企业'},
					{name:'下游企业'},
					{name:'银行'}
				]
			};
		},
		created() {
		},
		methods: {
			async check(){
				let params = {
					ID:this.ID,
					password: this.password
				}
				let res = await check(params)
				if (res === true) {
					if (res.type === 1) this.$router.push({name:'核心企业'})
				 	else if (res.type === 2) {
						 this.$router.push({name:'下游企业'})
					 } else if (res.type === 3) {
						 this.$router.push({name:'银行'})
					 }
				} else {
					this.$toast('该用户不存在')
				}
			},
			onLogin(values) {
			 	console.log('submit');
				if (this.ID === '' || this.password === '') {
					this.$toast("请输入完整信息")
				} else {
					this.check()	
				}
				
			}
  },


	}
</script>

<style lang="less" scoped>
	.page {
		position: absolute;
		width: 100%;
		height: 100%;
		background: url("../../assets/login-bg.png") no-repeat;
		background-size:100% 100%;
		display: flex;
		flex-direction: column;
		align-items: center;
		.box {
			width: 80%;
			height: 666px;
			margin-top: -190px;
			padding-top: 200px;
			box-shadow:0px 16px 16px 6px rgba(5,59,123,1);
		}
	}
	.logo{
		z-index: 9;
		text-align: center;
		margin-top: 130px;
		img{
			width:130px;
			height:130px;
			display: block;
			margin: 0 auto;
			border-radius: 50%;
			background: #fff;
		}
			p{
				font-size:35px;
				font-family:PingFangSC-Medium,PingFang SC;
				font-weight:500;
				color:rgba(255,255,255,1);
				line-height:44px;
				margin: 22px 0 80px;
			}
		}

	.btn{
		width: 100%;
		height:88px;
		line-height: 88px;
		background:#999;
		box-shadow:0px 8px 16px 6px rgba(5,59,123,1);
		border-radius:8px;
		font-size:30px;
		font-family:PingFangSC-Medium,PingFang SC;
		font-weight:500;
		color:#fff;
		margin-top: 50px;
		border: none;
	}
	/deep/ .van-form {
		width: 90%;
		margin: 15px auto;
	}

</style>