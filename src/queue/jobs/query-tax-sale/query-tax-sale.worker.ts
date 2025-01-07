import { Worker } from 'bullmq';
import QueryTaxSaleConfig from './query-tax-sale.config';
import QueryTaxSaleProcessor from './query-tax-sale.processor';

const instance = new QueryTaxSaleProcessor();
const {queueName, connection, isSandboxed} = QueryTaxSaleConfig;

const processor = isSandboxed ? `${__dirname}/query-tax-sale.slave.js` : instance.handle

const worker = new Worker(queueName, processor, {
  connection
})

worker.on('failed', instance.failed);
worker.on('completed', instance.completed)

export default worker