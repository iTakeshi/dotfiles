return {
  settings = {
    yaml = {
      schemas = {
        ["https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"] = "*.cfn.yml",
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
      },
      customTags = {
        "!And", "!Base64", "!Cidr", "!Equals", "!FindInMap sequence",
        "!GetAZs", "!GetAtt", "!If", "!ImportValue", "!Join sequence",
        "!Not", "!Or", "!Ref Scalar", "!Ref", "!Select", "!Split", "!Sub", "!fn",
      },
    },
  },
}
