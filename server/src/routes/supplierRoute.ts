import fastify, { FastifyInstance } from "fastify";
import ShortUniqueId from "short-unique-id";
import { z } from "zod";
import { prisma } from "../lib/prisma";

export async function supplierRoutes(fastify: FastifyInstance) {
  fastify.get("/fornecedores", async () => {
    const searchSupplier = await prisma.supplier.findMany({
      orderBy: {
        name: "asc",
      },
      select: {
        name: true,
        email: true,
        phone: true,
        cnpj: true,
      },
    });

    return { searchSupplier };
  });
  fastify.get("/fornecedores/count", async () => {
    const count = await prisma.supplier.count();

    return { count };
  });

  fastify.post("/fornecedores", async (request, reply) => {
    const createProviderBody = z.object({
      cnpj: z.string(),
      name: z.string(),
      phone: z.string(),
      email: z.string(),
      address: z.string(),
    });

    const { cnpj, name, phone, address, email } = createProviderBody.parse(
      request.body
    );

    const nameExists = await prisma.supplier.findUnique({
      where: {
        name,
      },
    });

    const emailExists = await prisma.supplier.findUnique({
      where: {
        email,
      },
    });

    const phoneExists = await prisma.supplier.findUnique({
      where: {
        phone,
      },
    });

    if (nameExists) {
      return reply.status(400).send({ message: "Fornecedor já cadastrado!" });
    }

    if (emailExists) {
      return reply
        .status(400)
        .send({ message: "Email já pertence à um Fornecedor cadastrado!" });
    }

    if (phoneExists) {
      return reply
        .status(400)
        .send({ message: "Telefone já pertence à um Fornecedor cadastrado!" });
    }

    await prisma.supplier.create({
      data: {
        cnpj,
        name,
        phone,
        email,
        address,
      },
    });

    return reply.status(201).send({ name, cnpj, phone, email, address });
  });
}
