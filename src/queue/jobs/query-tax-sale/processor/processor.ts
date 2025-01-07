import {dupNumberJsonPayload, PropertyJson} from './types';

async function getDupNumber(parcelNumber: String) : Promise<dupNumberJsonPayload> {
  const response = await fetch(`https://lowtaxinfo.com/lti-api/LowMobileTaxData.svc/api/PropertySearch?CorpCode=LAC&parcel=${parcelNumber}&page_number=0`)
  return await response.json() as dupNumberJsonPayload
}

async function getProperty(duplicateNumber: Number) : Promise<PropertyJson> {
  const response = await fetch(`https://lowtaxinfo.com/lti-api/LowMobileTaxData.svc/api/GetParcel?CorpCode=LAC&dup=${duplicateNumber}&PayYear=2025`)
  return await response.json() as PropertyJson
}

export async function processTaxSale(parcelNumber: String) {
  const dupNum = (await getDupNumber(parcelNumber)).Results[0].DuplicateNumber;
  const propertyInfo = (await getProperty(dupNum)).propertyInfo;
  console.log(propertyInfo);
}