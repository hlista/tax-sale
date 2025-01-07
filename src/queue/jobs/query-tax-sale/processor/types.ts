export interface dupNumberObject {
  DuplicateNumber:Number
}

export interface dupNumberJsonPayload {
  Results:Array<dupNumberObject>
}

export interface AssessedValuesJson {
  Amount: number,
  Description: String,
  PayYear: Number
}

export interface ExemptionsDeductionsJson {
  AMOUNT: number,
  DESCRIPTION: String
}

export interface PropertyJson{
  propertyInfo: PropertyInfoJsonPayload,
  assessedValues: Array<AssessedValuesJson>,
  exemptionsDeductions: Array<ExemptionsDeductionsJson>
}

export interface PropertyInfoJsonPayload{
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