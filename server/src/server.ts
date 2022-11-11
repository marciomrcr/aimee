import cors from "@fastify/cors";
import Fastify from "fastify";
import { authRoutes } from "./routes/auth";
import { categoriaPostsRoutes } from "./routes/categoriaPosts";
import { categoryRoutes } from "./routes/categoryRoute";
import { clienteRoutes } from "./routes/consumer";
import { postRoutes } from "./routes/post";
import { productRoutes } from "./routes/productRoute";
import { supplierRoutes } from "./routes/supplierRoute";
import { userRoutes } from "./routes/user";

async function bootstrap() {
  const fastify = Fastify({
    logger: true,
  });

  await fastify.register(cors, {
    origin: true,
  });

  await fastify.register(authRoutes);
  await fastify.register(clienteRoutes);
  await fastify.register(supplierRoutes);
  await fastify.register(categoryRoutes);
  await fastify.register(productRoutes);
  await fastify.register(postRoutes);
  await fastify.register(categoriaPostsRoutes);
  await fastify.register(userRoutes);

  await fastify.listen({ port: 3333 /*host: '0.0.0.0'*/ });
}

bootstrap();
