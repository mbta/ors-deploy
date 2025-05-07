# Changeset Generation Script

Script is meant to automate the creation of changeset files to keep track of changes made to Open
Street Map data. Script builds a dockerfile with `osmctools` to perform operations on OSM data.
`.osc` changeset files in `/changesets` will be applied to the OSM data when `ors-deploy` is deployed.

## Usage

`$ bash generate_changeset.sh --search-key="<key>" --search-value="<value>"`

## Command line args

| Key              | Default | Example                        | Description |
| ---------------- | ------- | ------------------------------ | ----------- |
| `--search-key`   | N/A     | `--search-key=short_name`      | Field to filter `data.osm.pbf` data. Must be a field present on way Nodes. |
| `--search-value` | N/A     | `--search-value="VFW Parkway"` | Value, used in combination with `--search-key` to filter ways within `data.osm.pbf` file |
| `--cached`       | `false` | `--cached=true`                | If true, will not download osm data again and will attempt to re-use existing `data.osm.pbf` file |
