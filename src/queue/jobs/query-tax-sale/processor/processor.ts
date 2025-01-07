import {dupNumberJsonPayload, PropertyJson} from './types';
import { prisma } from "../../../../index";

async function getDupNumber(parcelNumber: String) : Promise<dupNumberJsonPayload> {
  const response = await fetch(`https://lowtaxinfo.com/lti-api/LowMobileTaxData.svc/api/PropertySearch?CorpCode=LAC&parcel=${parcelNumber}&page_number=0`)
  return await response.json() as dupNumberJsonPayload
}

async function getProperty(duplicateNumber: Number) : Promise<PropertyJson> {
  const response = await fetch(`https://lowtaxinfo.com/lti-api/LowMobileTaxData.svc/api/GetParcel?CorpCode=LAC&dup=${duplicateNumber}&PayYear=2025`)
  return await response.json() as PropertyJson
}

export async function processTaxSale(parcelNumber: string) {
  const dupNum = (await getDupNumber(parcelNumber)).Results[0].DuplicateNumber;
  const body = await getProperty(dupNum)
  const taxSale = (body.propertyInfo.TaxSaleSold === 'T') ? true : false;
  const propertyInfo = body.propertyInfo;
  const ownerName = propertyInfo.OwnerName;
  const mailingAddress1 = propertyInfo.MAILINGADDRESS1;
  const mailingAddress2 = propertyInfo.MAILINGADDRESS2;
  const mailingCity = propertyInfo.MAILINGCITY;
  const mailingState = propertyInfo.MAILINGSTATE;
  const mailingZip = propertyInfo.MAILINGZIPCODE;
  const propertyAddress1 = propertyInfo.PROPERTYADDRESS1;
  const propertyAddress2 = propertyInfo.PROPERTYADDRESS2;
  const propertyCity = propertyInfo.PROPERTYCITY;
  const propertyState = propertyInfo.PROPERTYSTATE;
  const propertyZip = propertyInfo.PROPERTYZIPCODE;
  const mailingAddressFull = `${ownerName} ${mailingAddress1} ${mailingAddress2} ${mailingCity} ${mailingState} ${mailingZip}`;
  const propertyAddressFull = `${propertyAddress1} ${propertyAddress2} ${propertyCity} ${propertyState} ${propertyZip}`;

  let assessedValue = 0
  body.assessedValues.forEach(assessedValueItem => {
    assessedValue += assessedValueItem.Amount;
  })
  const homestead_deduction = body.exemptionsDeductions.find((element) => element.DESCRIPTION === "Std Hmstd Deduct")?.AMOUNT

  const updateProperty = await prisma.property.update({
    where: {
      parcelNumber: parcelNumber
    },
    data: {
      taxSale: taxSale,
      location: propertyAddressFull,
      nameAndAddress: mailingAddressFull,
      grossAccessedValueOfProperty: assessedValue,
      homesteadDeduction: homestead_deduction
    }
  })
}