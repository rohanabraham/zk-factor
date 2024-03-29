mod public_key_note;
// use dep::std;

// Account contract that uses Schnorr signatures for authentication.
// The signing key is stored in an immutable private note and should be different from the encryption/nullifying key.
contract ZKFactor {
    use dep::std;

    use dep::aztec::prelude::{AztecAddress, FunctionSelector, NoteHeader, PrivateContext, PrivateImmutable, PrivateSet, PrivateMutable, Map, PublicMutable};

    use dep::aztec::{context::Context,oracle::get_public_key::get_public_key};
    use dep::authwit::{
        entrypoint::{app::AppPayload, fee::FeePayload}, account::AccountActions,
        auth_witness::get_auth_witness
    };

    use crate::public_key_note::{PublicKeyNote, PUBLIC_KEY_NOTE_LEN};
    use dep::value_note::value_note::{ValueNote, VALUE_NOTE_LEN};

    struct Point {
        x: i64,
        y: i64       
    }

    struct PointsCombinationDistance {
        point1: Point,
        point2: Point,
        distance: i64
    }


    struct Storage {
        // docs:start:storage
        signing_public_key: PrivateImmutable<PublicKeyNote>,
        //reference_points: Map<Field, PrivateImmutable<FieldNote>>,
        reference_points_x: Map<Field, PrivateMutable<ValueNote>>,
        reference_points_y: Map<Field, PrivateMutable<ValueNote>>,       
        //totp_secret: PrivateImmutable<FieldNote>,
        // docs:end:storage
    }

    global ACCOUNT_ACTIONS_STORAGE_SLOT = 2;

     #[aztec(private)]
    fn constructor() {}


    // Note: If you globally change the entrypoint signature don't forget to update default_entrypoint.ts file
    #[aztec(private)]
    fn entrypoint(app_payload: pub AppPayload, fee_payload: pub FeePayload) {
        let actions = AccountActions::private(&mut context, ACCOUNT_ACTIONS_STORAGE_SLOT, is_valid_impl);
        actions.entrypoint(app_payload, fee_payload);
    }

    #[aztec(private)]
    fn spend_private_authwit(inner_hash: Field) -> Field {
        let actions = AccountActions::private(&mut context, ACCOUNT_ACTIONS_STORAGE_SLOT, is_valid_impl);
        actions.spend_private_authwit(inner_hash)
    }

    #[aztec(public)]
    fn spend_public_authwit(inner_hash: Field) -> Field {
        let actions = AccountActions::public(&mut context, ACCOUNT_ACTIONS_STORAGE_SLOT, is_valid_impl);
        actions.spend_public_authwit(inner_hash)
    }

    #[aztec(private)]
    #[aztec(internal)]
    fn cancel_authwit(outer_hash: Field) {
        context.push_new_nullifier(outer_hash, 0);
    }

    #[aztec(public)]
    #[aztec(internal)]
    fn approve_public_authwit(outer_hash: Field) {
        let actions = AccountActions::public(&mut context, ACCOUNT_ACTIONS_STORAGE_SLOT, is_valid_impl);
        actions.approve_public_authwit(outer_hash)
    }

    #[contract_library_method]
    fn is_valid_impl(context: &mut PrivateContext, outer_hash: Field) -> bool {
        // docs:start:entrypoint
        // Load public key from storage
        let storage = Storage::init(Context::private(context));
        // docs:start:get_note
        let public_key = storage.signing_public_key.get_note();
        // docs:end:get_note
        // Load auth witness
        let witness: [Field; 64] = get_auth_witness(outer_hash);
        let mut signature: [u8; 64] = [0; 64];
        for i in 0..64 {
            signature[i] = witness[i] as u8;
        }

        // Verify signature of the payload bytes
        let verification = std::schnorr::verify_signature(
            public_key.x,
            public_key.y,
            signature,
            outer_hash.to_be_bytes(32)
        );
        assert(verification == true);
        // docs:end:entrypoint
        true
    }



    #[aztec(private)]
     fn setReferencePoint( position: Field, x: Field, y: Field) {    
        // this = context.this_address(); 
        let mut point_note_x = ValueNote::new(x, context.msg_sender());   
        let mut point_note_y = ValueNote::new(y, context.msg_sender());   
        //storage.reference_points.at(position).initialize(&mut point_note, true);
         storage.reference_points_x.at(position).initialize(&mut point_note_x, true);
         storage.reference_points_y.at(position).initialize(&mut point_note_y, true);
     }

    
    unconstrained fn getReferencePoint( position: Field) -> pub ValueNote {  
         storage.reference_points_x.at(position).view_note()
     }

     #[aztec(private)]
     fn verifyReferencePoint(position: Field, x: Field, y: Field)  {
         let point_note_x = storage.reference_points_x.at(position).get_note(false);
         let point_note_y = storage.reference_points_y.at(position).get_note(false);
        assert(point_note_x.value == x);
        assert(point_note_y.value == y);        
     }

     #[aztec(private)]
     fn verifySafeDistanceReferencePoint(position: Field, x: Field, y: Field)  {
         let point_note_x = storage.reference_points_x.at(position).get_note(false);
         let point_note_y = storage.reference_points_y.at(position).get_note(false);
        assert(point_note_x.value == x);
        assert(point_note_y.value == y);        
     }

    #[aztec(private)]
    #[aztec(internal)]
    fn calculateDistance(outer_hash: Field) {
        context.push_new_nullifier(outer_hash, 0);
    }

    
}