import sys
sys.path.insert(0, 'src/freelancer_crawler')

from connect import inserir_user, update, engine
from dotenv import load_dotenv
import psycopg

load_dotenv()

# Get database credentials
import os
POSTGRES_PASSWORD = os.getenv('POSTGRES_PASSWORD')
POSTGRES_USER = os.getenv('POSTGRES_USER')
POSTGRES_DB = os.getenv('POSTGRES_DB')
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = os.getenv('DB_PORT', '5432')

# Test user data
test_username = "test_user_update"
test_email = "test@example.com"
test_password = "original_password"

# New data for update
new_username = "updated_test_user"
new_email = "updated@example.com"
new_password = "updated_password"

print("=" * 60)
print("Testing update() function")
print("=" * 60)

try:
    # Step 1: Insert a test user
    print("\n1️⃣  Inserting test user...")
    inserir_user(test_username, test_email, test_password)
    print(f"   ✅ User inserted: {test_username}")
    
    # Step 2: Get the user_id
    print("\n2️⃣  Fetching user_id from database...")
    with psycopg.connect(
        f"postgresql://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{DB_HOST}:{DB_PORT}/{POSTGRES_DB}"
    ) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id FROM users WHERE username = %s", (test_username,))
            result = cur.fetchone()
            if not result:
                print("   ❌ User not found!")
                sys.exit(1)
            user_id = result[0]
            print(f"   ✅ User ID: {user_id}")
    
    # Step 3: Update the user with the fixed function
    print("\n3️⃣  Calling update() function...")
    update(user_id, new_username, new_email, new_password)
    print(f"   ✅ Update executed")
    
    # Step 4: Verify the update in database
    print("\n4️⃣  Verifying update in database...")
    with psycopg.connect(
        f"postgresql://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{DB_HOST}:{DB_PORT}/{POSTGRES_DB}"
    ) as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT username, email FROM users WHERE id = %s",
                (user_id,)
            )
            result = cur.fetchone()
            if result:
                db_username, db_email = result
                print(f"   Username: {db_username}")
                print(f"   Email: {db_email}")
                
                # Verify values match
                if db_username == new_username and db_email == new_email:
                    print(f"   ✅ Update successful! Values match.")
                else:
                    print(f"   ❌ Update failed! Values don't match.")
                    print(f"      Expected username: {new_username}, got: {db_username}")
                    print(f"      Expected email: {new_email}, got: {db_email}")
                    sys.exit(1)
            else:
                print("   ❌ User not found after update!")
                sys.exit(1)
    
    print("\n" + "=" * 60)
    print("✅ All tests PASSED!")
    print("=" * 60)
    
except Exception as e:
    print(f"\n❌ Error: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
