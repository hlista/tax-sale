import { Job } from 'bullmq';
import { ProcessorDef } from '../processor.def'
import { processTaxSale } from './processor/processor';

export default class QueryTaxSaleProcessor implements ProcessorDef {
  constructor() {}

  async handle(job: Job) {
    console.log("here");
    processTaxSale(job.data.parcelNumber);
  }

  failed(job?: Job) {
    console.log({ job })
  }

  completed(job: Job) {
    console.log(`completed ${job.data.parcelNumber}`)
  }
}