//! Print logref's `api.json` op surface. `scripts/gen.sh` writes stdout to
//! `schema/api.json`, then hands it to `fluessig-gen`.

fn main() {
    print!("{}", logref_schema::fluessig_catalog::api_to_json());
}
