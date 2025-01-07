import { Queue } from 'bullmq';
import queryTaxSaleConfig from './query-tax-sale.config'

const { queueName, connection, defaultJobOptions} = queryTaxSaleConfig

const QueryTaxSaleQueue = new Queue(queueName, {
  connection,
  defaultJobOptions
})

export default QueryTaxSaleQueue;