import { Job } from 'bullmq';
import { ProcessorDef } from '../processor.def'

interface dupNumberObject {
  DuplicateNumber:Number
}

interface dupNumberJsonPayload {
  Results:Array<dupNumberObject>
}

async function getDupNumber(parcelNumber: String) : Promise<dupNumberJsonPayload> {
  const response = await fetch(`https://lowtaxinfo.com/lti-api/LowMobileTaxData.svc/api/PropertySearch?CorpCode=LAC&parcel=${parcelNumber}&page_number=0`)
  return await response.json() as dupNumberJsonPayload
}

export default class SendEmailProcessor implements ProcessorDef {
  constructor() {}

  async handle(job: Job) {
    const pid = "46-06-36-365-007.000-043";
    const dupNum = (await getDupNumber(pid)).Results[0].DuplicateNumber;
    console.log(dupNum);
  }

  failed(job?: Job) {
    console.log({ job })
  }

  completed(job: Job) {
    console.log({ job })
  }
}