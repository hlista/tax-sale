import { Job } from 'bullmq';
import { ProcessorDef } from '../processor.def'

interface dupNumberObject {
  DuplicateNumber:Number
}

interface dupNumberJsonPayload {
  Results:Array<dupNumberObject>
}

interface PropertyJson{
  propertyInfo: PropertyInfoJsonPayload
}

interface PropertyInfoJsonPayload{
  TaxSaleSold: String,
  OwnerName: String,
  MAILINGADDRESS1: String,
  MAILINGADDRESS2: String,
  MAILINGCITY: String,
  MAILINGSTATE: String,
  MAILINGZIPCODE: String,
  PROPERTYADDRESS1: String,
  PROPERTYADDRESS2: String,
  PROPERTYCITY: String,
  PROPERTYSTATE: String,
  PROPERTYZIPCODE: String,
}

async function getDupNumber(parcelNumber: String) : Promise<dupNumberJsonPayload> {
  const response = await fetch(`https://lowtaxinfo.com/lti-api/LowMobileTaxData.svc/api/PropertySearch?CorpCode=LAC&parcel=${parcelNumber}&page_number=0`)
  return await response.json() as dupNumberJsonPayload
}

async function getProperty(duplicateNumber: Number) : Promise<PropertyJson> {
  const response = await fetch(`https://lowtaxinfo.com/lti-api/LowMobileTaxData.svc/api/GetParcel?CorpCode=LAC&dup=${duplicateNumber}&PayYear=2025`)
  return await response.json() as PropertyJson
}

export default class SendEmailProcessor implements ProcessorDef {
  constructor() {}

  async handle(job: Job) {
    const pid = "46-06-36-365-007.000-043";
    const dupNum = (await getDupNumber(pid)).Results[0].DuplicateNumber;
    const propertyInfo = (await getProperty(dupNum)).propertyInfo;
    console.log(propertyInfo);
  }

  failed(job?: Job) {
    console.log({ job })
  }

  completed(job: Job) {
    console.log({ job })
  }
}