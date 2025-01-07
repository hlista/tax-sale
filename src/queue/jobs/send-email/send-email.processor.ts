import { Job } from 'bullmq';
import { ProcessorDef } from '../processor.def'

export default class SendEmailProcessor implements ProcessorDef {
  constructor() {}

  async handle(job: Job) {
    console.log("handle");
  }

  failed(job?: Job) {
    console.log("failed")
  }

  completed(job: Job) {
    console.log("completed")
  }
}