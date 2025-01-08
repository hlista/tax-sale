import { ApolloServer } from "apollo-server";
import { ApolloServerPluginLandingPageLocalDefault } from "apollo-server-core";
import { QueueUtils } from './queue';
import { context } from "./context"

import { schema } from "./schema";
export const server = new ApolloServer({
    schema,
    context,
    introspection: true,
    plugins: [ApolloServerPluginLandingPageLocalDefault]
});

export { prisma } from './context'

const port = 3000;
server.listen({port}).then(({ url }) => {
    QueueUtils.initializeJobs();
    console.log(`🚀  Server ready at ${url}`);
});
