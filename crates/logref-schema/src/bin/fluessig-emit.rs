//! Print logref's `catalog.json`. `scripts/gen.sh` writes stdout to
//! `schema/catalog.json`, then hands it to `fluessig-gen`.

fn main() {
    print!("{}", logref_schema::fluessig_catalog::to_json());
}
