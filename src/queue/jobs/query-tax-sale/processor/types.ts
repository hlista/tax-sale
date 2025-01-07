export interface dupNumberObject {
  DuplicateNumber:Number
}

export interface dupNumberJsonPayload {
  Results:Array<dupNumberObject>
}

export interface PropertyJson{
  propertyInfo: PropertyInfoJsonPayload
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