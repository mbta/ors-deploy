# Changeset Generation Script

Script is meant to automate the creation of changeset files to keep track of changes made to Open
Street Map data. Script builds a dockerfile with `osmctools` to perform operations on OSM data.
`.osc` changeset files in `/changesets` will be applied to the OSM data when `ors-deploy` is deployed.

## Usage

`$ bash generate_changeset.sh --search-key "<key>" --search-value "<value>"`

## Command line args

| Arg                               | Required | Default | Example                        | Description |
| --------------------------------- | -------- | ------- | ------------------------------ | ----------- |
| Search Key `-k, --search-key`     | true     | N/A      | `-k short_name`               | Field to filter `data.osm.pbf` data. Must be a field present on way Nodes. Note: can use `-k short_name!` to negate value provided. |
| Search Value `-v, --search-value` | true     | N/A      | `-v "VFW Parkway"`            | Value, used in combination with `-k` to filter ways within `data.osm.pbf` file |
| Cached `-c, --cached`             | false    | `false`  | `-c`                          | If provided, will attempt to re-use existing `data.osm.pbf` file |

# Split Changeset Script

Script to split up a changeset by name and create an individual changeset for each name

## Usage

`$ bash split_changeset.sh ../<changeset file name>`

note: this will delete the input file since its contents have been replaced by the split out files.
