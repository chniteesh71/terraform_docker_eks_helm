FROM node:18 AS build
WORKDIR /app
RUN git clone https://github.com/chniteesh71/terraform_docker_eks_helm.git .
WORKDIR /app/appsrccode
RUN npm install
RUN npm run build

FROM node:20-alpine
WORKDIR /app
COPY --from=build /app/appsrccode .
EXPOSE 3000
CMD ["npm", "start"]
