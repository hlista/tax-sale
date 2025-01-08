import { extendType, nonNull, objectType, stringArg, idArg, intArg, inputObjectType, enumType, arg, list } from "nexus";
import { QueryTaxSaleQueue, MailbotQueue } from '../queue';
import { JobsEnum } from '../queue';

export const Property = objectType({
  name: "Property",
  definition(t) {
    t.nonNull.int("id");
    t.nonNull.string("parcelNumber");
    t.boolean("taxSale");
    t.string("location");
    t.string("nameAndAddress");
    t.string("grossAccessedValueOfProperty");
    t.string("homesteadDeduction");
    t.string("mortgageDeduction");
   // t.nonNull.dateTime("updatedAt");
   // t.nonNull.dateTime("createdAt")
  }
})

// export const PropertyQuery = extendType({
//   type: "Query",
//   definition(t) {
//     t.nonNull.list.nonNull.field("properties", {
//       type: "Property",
//       async resolve(parent, args, context) {
//         const schedulers = await QueryTaxSaleQueue.getJobSchedulers(0, 9, true);
//         console.log('Current job schedulers:', schedulers);

//         return await context.prisma.property.findMany()
//       }
//     })
//   }
// })

// export const PropertyMutation = extendType({
//   type: "Mutation",
//   definition(t) {
//     t.nonNull.field("createProperty", {
//       type: "Property",
//       args: {
//         parcelNumber: nonNull(stringArg())
//       },
//       async resolve(parent, args, context) {
//         const { parcelNumber } = args
//         const property = await context.prisma.property.create({
//           data: {
//             parcelNumber: parcelNumber
//           }
//         });
//         QueryTaxSaleQueue.upsertJobScheduler(
//           `repeatable-property-search-${property.parcelNumber}`,
//           {
//             every: 10000
//           },
//           {
//             name: JobsEnum.QUERY_TAX_SALE,
//             data: {
//               parcelNumber: property.parcelNumber
//             }
//           }
//         )
//         return property;
//       }
//     })
//   }
// })