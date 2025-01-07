import { SendEmailWorker, QueryTaxSaleWorker} from './jobs';

const WorkerMap = new Map([
  ['SendEmail', SendEmailWorker],
  ['QueryTaxSale', QueryTaxSaleWorker]
]);

/**
 * Initialize workers by binding an event listener to it
 */

export function initializeJobs() {
  WorkerMap.forEach((worker) => {
    worker.on('error', (err: any) => {
      console.error(err);
    });
  })
}
