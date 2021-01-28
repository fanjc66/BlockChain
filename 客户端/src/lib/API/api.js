import { get } from 'core-js/fn/dict'
import { fetch, post, patch, del } from '../http'

export function check(params) {
    return post('check',params)
}

export function getRecord(params) {
    return fetch('record',params)
}

export function getBalance (params) {
	return fetch('balance',params)
}

export function createVoucher(params) {
    return post('createVoucher',params)
}

export function transferVoucher(params) {
    return poset('transferVoucher', params)
}

export function financingByVoucher(params) {
    return post('financingByVoucher',params)
}

export function payVoucher(params) {
    return post('payVoucher',params)
}