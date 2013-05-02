//
//  SearchViewController.m
//  Symptomm
//
//  Created by Harrison Sweeney on 1/05/13.
//  Copyright (c) 2013 Harrison Sweeney. All rights reserved.
//

#import "SearchViewController.h"


@implementation SearchViewController

@synthesize searchDisplayController;
@synthesize searchBar;
@synthesize allItems;
@synthesize searchResults;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Initialize the main array. This is a temporary measure until it is fetched remotely.
    NSArray *items = [[NSArray alloc] initWithObjects: @"ADHD", @"Abdominal Aortic Aneurysm", @"Abdominal Cancer", @"Abdominal Discomfort", @"Abdominal Hernia", @"Abdominal Mass", @"Abdominal Muscle Spasm", @"Abdominal Pain", @"Abdominal Swelling", @"Abdominal Symptoms", @"Abnormal Vaginal Bleeding", @"Abscess", @"Accelerated Hypertension", @"Aches", @"Acidosis", @"Acne", @"Acoustic Neuroma", @"Actinomycetales Infection", @"Acute Appendicitis", @"Acute Gastritis", @"Acute Meningitis", @"Acute Nausea and Vomiting", @"Acute Sinusitis", @"Addison's Disease", @"Adenopathy", @"Adrenal Cancer", @"Adrenal Gland Symptoms", @"Adult Panic Anxiety Syndrome", @"Aggression", @"Alcohol Abuse", @"Alcoholic Liver Disease", @"Alcoholic Neuropathy", @"Alcoholism", @"Allergic Reaction", @"Allergies", @"Alopecia", @"Amenorrhea", @"Amyloidosis", @"Amyotrophic Lateral Sclerosis", @"Anal Fissure", @"Anal Symptoms", @"Anaphylaxis", @"Anemia", @"Aneurysm", @"Angina", @"Angioedema", @"Ankle Lump", @"Ankle Rash", @"Ankle Swelling", @"Ankle Symptoms", @"Ankylosing Spondylitis", @"Anorexia Nervosa", @"Anoxia", @"Anxiety", @"Arachnoid Cysts", @"Arm Burning Sensation", @"Arm Lump", @"Arm Numbness", @"Arm Pain", @"Arm Paresthesia", @"Arm Rash", @"Arm Symptoms", @"Arm Weakness", @"Arrhythmias", @"Arterial Insufficiency", @"Arthralgia", @"Arthritis", @"Ascites", @"Asthma", @"Asthmatic Bronchitis", @"Atherosclerosis", @"Atrophic Vaginitis", @"Autism", @"Autoimmune Diseases", @"Autoimmune Hepatitis", @"Autoimmune Thyroid Diseases", @"Back Burning Sensation", @"Back Pain", @"Back Rash", @"Back Spasm", @"Backache", @"Bacterial Digestive Infections", @"Bacterial Diseases", @"Bacterial Meningitis", @"Bad Breath", @"Bad Taste", @"Bad Taste in Mouth", @"Balance Symptoms", @"Balanitis", @"Barking Cough", @"Basal Cell Carcinoma", @"Basilar Artery Migraine", @"Behavioral Disorders", @"Behavioral Symptoms", @"Behind Knee Lump", @"Behind Knee Pain", @"Behind Knee Swelling", @"Belching", @"Bent Penis", @"Beriberi", @"Bipolar Disorder", @"Bitter Taste in Mouth", @"Black Stool", @"Blackouts", @"Bladder Cancer", @"Bladder Pain", @"Bladder Symptoms", @"Bleeding After Sex", @"Bleeding Disorders", @"Bleeding From Ear", @"Bleeding Gums", @"Bleeding Nipple", @"Bleeding Symptoms", @"Blepharitis", @"Blisters", @"Blood Cancer", @"Blood Clots", @"Blood In Urine", @"Blood Vessel Symptoms", @"Bloodshot Eyes", @"Bloody Diarrhea", @"Bloody Stool", @"Blue Hands", @"Blue Lips", @"Blurred Vision", @"Blurred Vision in One Eye", @"Body Odor", @"Boil", @"Bone Symptoms", @"Borderline Personality Disorder", @"Botulism Food Poisoning", @"Bowel Obstruction", @"Bowel Problems", @"Brachial Plexus Injury", @"Brain Cancer", @"Brain Swelling", @"Brain Symptoms", @"Breast Abscess", @"Breast Burning Sensation", @"Breast Cancer", @"Breast Duct Papilloma", @"Breast Itch", @"Breast Lump", @"Breast Pain", @"Breast Rash", @"Breast Swelling", @"Breast Symptoms", @"Breast Tenderness", @"Breathing Difficulties", @"Breathing Symptoms", @"Broken Finger", @"Broken Foot", @"Broken Nose", @"Broken Toe", @"Bronchiectasis", @"Bronchitis", @"Brown Urine", @"Bruising", @"Buffalo Hump", @"Bulging Veins", @"Bulimia Nervosa", @"Burning Eyes", @"Burning Feet", @"Burning Legs", @"Burning Symptoms", @"Bursitis", @"Butterfly Rash", @"Buttock Pain", @"Buttock Rash", @"Buzzing in Ears", @"Calcification", @"Calcium Deficiency", @"Calf Pain", @"Cancer", @"Candida", @"Candidiasis Information", @"Canker Sores", @"Carbuncle", @"Carpal Tunnel Syndrome", @"Cat Scratch Disease", @"Cataracts", @"Celiac Disease", @"Cellulitis", @"Cerebellar Ataxia Syndrome", @"Cerebral Atrophy", @"Cerebral Hemorrhage", @"Cervical Cancer", @"Cervical Polyps", @"Cervical Spondylosis", @"Cervicitis", @"Cervix Symptoms", @"Chalazion", @"Cheek Rash", @"Cheek Swelling", @"Cheek Symptoms", @"Chest Burning", @"Chest Burning Sensation", @"Chest Cold", @"Chest Discomfort", @"Chest Lump", @"Chest Pain", @"Chest Pressure", @"Chest Rash", @"Chest Symptoms", @"Chest Tightness", @"Chiari Malformation", @"Chickenpox", @"Chills", @"Chin Lump", @"Chlamydia", @"Cholecystitis", @"Cholelithiasis", @"Cholera", @"Chronic Appendicitis", @"Chronic Bronchitis", @"Chronic Fatigue Syndrome", @"Chronic Inflammatory Demyelinating Polyneuropathy", @"Chronic Kidney Disease", @"Chronic Sinusitis", @"Circulation Symptoms", @"Cirrhosis of the Liver", @"Clammy Skin", @"Clitoris Pain", @"Cloudy Urine", @"Cloudy Vision", @"Coagulopathy", @"Cognitive Impairment", @"Cold Feet", @"Cold Hands", @"Cold Sores", @"Cold Sweat", @"Colitis", @"Collapsed Lung", @"Colorectal Cancer", @"Common Cold", @"Compartment Syndrome", @"Concentration Difficulty", @"Confusion", @"Congestive Cardiac Failure", @"Congestive Heart Failure", @"Conjunctivitis", @"Connective Tissue Disorders", @"Constipation", @"Contact Dermatitis", @"Cough", @"Coughing Blood", @"Coughing Spasms", @"Cracked Lips", @"Cracked Mouth Corner", @"Cracked Skin", @"Cradle Cap", @"Crepitus", @"Crohn's Disease", @"Croup", @"Crying Infant", @"Cushing's Syndrome", @"Cyanosis", @"Cystic Fibrosis", @"Cystitis", @"Cysts", @"Cytomegalovirus", @"Dandruff", @"Dark Circles Under Eyes", @"Dark Circles Under Eyes in Children", @"Dark Stool", @"Darkened Skin", @"Darkened Urine", @"Deep Vein Thrombosis", @"Dehydration", @"Dementia", @"Dengue Fever", @"Dengue Hemorrhagic Fever", @"Dental Abscess", @"Dental Caries", @"Dental Symptoms", @"Depression", @"Depressive Symptoms", @"Dermatitis", @"Dermatomyositis", @"Dermoid Cyst", @"Developmental Problems", @"Diabetes", @"Diabetes Insipidus", @"Diabetic Ketoacidosis", @"Diarrhea", @"Digestive Symptoms", @"Dilated Pupils", @"Discoid Eczema", @"Discoid Lupus Erythematosus", @"Dislocated Jaw", @"Diverticular Disease", @"Dizziness", @"Double Vision", @"Drowsiness", @"Drug Abuse", @"Dry Cough", @"Dry Mouth", @"Dry Nose", @"Dry Scaly Skin", @"Dry Socket", @"Dry Throat", @"Duodenal Ulcer", @"Duodenitis", @"Dust Mite Allergies", @"Dysentery", @"Ear Burning Sensation", @"Ear Fullness", @"Ear Infection", @"Ear Itching", @"Ear Lump", @"Ear Sounds", @"Ear Swelling", @"Ear Symptoms", @"Ear Wax", @"Earache", @"Easy Bruising", @"Ectopic Pregnancy", @"Eczema", @"Edema", @"Elbow Lump", @"Elbow Pain", @"Elbow Rash", @"Elbow Symptoms", @"Electrolyte Imbalance", @"Elevated Blood Ammonia Level", @"Elevated Creatine Kinase", @"Embolism", @"Emotional Symptoms", @"Emphysema", @"Encephalitis", @"Endocrine Disorders", @"Endometrial Hyperplasia", @"Endometriosis", @"Enlarged Liver", @"Enlarged Liver and Spleen", @"Enlarged Ovary", @"Enlarged Prostate", @"Enlarged Testicle", @"Epididymitis", @"Epigastric Pain", @"Epilepsy", @"Epstein-Barr Virus", @"Erythema Nodosum", @"Esophagitis", @"Esophagus Symptoms", @"Excessive Hunger", @"Eye Bleeding", @"Eye Blinking Symptoms", @"Eye Cancer", @"Eye Conditions", @"Eye Discharge", @"Eye Herpes", @"Eye Infection", @"Eye Inflammation", @"Eye Pain", @"Eye Swelling", @"Eye Symptoms", @"Eye Twitching", @"Eyeball Spots", @"Eyelid Lump", @"Eyelid Pain", @"Eyelid Swelling", @"Eyelid Symptoms", @"Eyelid Twitch", @"Face Swelling", @"Face Symptoms", @"Facial Pain", @"Facial Rash", @"Facial Spasms", @"Fainting", @"Fatigue", @"Fatty Liver", @"Fecal Impaction", @"Feeling Cold", @"Female Sexual Symptoms", @"Fetal Alcohol Syndrome", @"Fever Information", @"Fibroadenoma", @"Fibroma", @"Fibromyalgia", @"Finger Clubbing", @"Finger Numbness", @"Finger Pain", @"Finger Paresthesia", @"Finger Symptoms", @"Finger lump", @"Fingernail Symptoms", @"Flaky Skin", @"Flatulence", @"Flu-like Symptoms", @"Fluid Retention", @"Flushing", @"Folliculitis", @"Food Allergies", @"Food Poisoning", @"Foot Bruise", @"Foot Itch", @"Foot Lump", @"Foot Numbness", @"Foot Pain", @"Foot Rash", @"Foot Swelling", @"Foot Symptoms", @"Forearm Pain", @"Forehead Pain", @"Forehead Rash", @"Foreskin Symptoms", @"Forgetfulness", @"Fractured Femur", @"Fractures", @"Frequent Bowel Movements", @"Frequent Urination", @"Fungal Infections", @"Gallbladder Symptoms", @"Gallstones", @"Gastric Ulcer", @"Gastritis", @"Gastroenteritis", @"Gastrointestinal Bleeding", @"Genital Herpes", @"Genital Itching", @"Genital Rash", @"Genital Sores", @"Genital Warts", @"Giardia Infection", @"Gigantism", @"Gingivitis", @"Glaucoma", @"Glomerulonephritis", @"Glossitis", @"Goiter", @"Gonorrhea", @"Gout", @"Grand Mal Seizures", @"Green Stool", @"Green Urine", @"Green Vaginal Discharge", @"Groin Lump", @"Groin Pain", @"Groin Rash", @"Groin Swelling", @"Groin Symptoms", @"Gum Cancer", @"Gum Pain", @"Gum Symptoms", @"Gynecomastia", @"HIV/AIDS", @"Hair Loss", @"Hair Symptoms", @"Hallucinations", @"Hand Cramps", @"Hand Numbness", @"Hand Pain", @"Hand Rash", @"Hand Swelling", @"Hand Symptoms", @"Hand Tremor", @"Hay Fever", @"Head Injury", @"Head Lice", @"Head Symptoms", @"Headache", @"Hearing Voices", @"Heart Attack", @"Heart Cancer", @"Heart Conditions", @"Heart Disease", @"Heart Symptoms", @"Heartburn", @"Heat Rash", @"Heavy Periods", @"Helicobacter pylori", @"Hematoma", @"Hemochromatosis", @"Hemophilia", @"Hemorrhoids", @"Hepatitis", @"Hernia", @"Herniated Disc", @"Herpes", @"Hiatal Hernia", @"Hiccups", @"High Blood Calcium", @"High Blood Iron", @"High Blood Pressure", @"High Cholesterol", @"High Fever", @"High Platelets", @"Hip Cancer", @"Hip Pain", @"Hives", @"Hoarse Voice", @"Hodgkin’s Disease", @"Hookworm Disease", @"Hot Flashes", @"Human Papillomavirus", @"Hydrocephalus", @"Hydronephrosis", @"Hypercalcemia", @"Hyperparathyroidism", @"Hypertension", @"Hyperthyroidism", @"Hyperventilation", @"Hypocalcemia", @"Hypothermia", @"Hypothyroidism", @"Hypovolemia", @"Immune Deficiency Conditions", @"Impetigo", @"Impotence", @"Increased Intracranial Pressure", @"Indigestion", @"Infant Symptoms", @"Inflammatory Bowel Disease", @"Inguinal Hernia", @"Injury", @"Insomnia", @"Intercostal Neuralgia", @"Intermittent Claudication", @"Internal Bleeding", @"Interstitial Cystitis", @"Intestinal Conditions", @"Intestinal Flu", @"Iodine Deficiency", @"Iron Deficiency Anemia", @"Irritability", @"Irritable Bowel Syndrome", @"Ischemia", @"Ischemic Heart Disease", @"Itching All Over", @"Itching Skin", @"Itchy Eyelid", @"Itchy Rash", @"Itchy Scalp", @"Jaundice", @"Jaw Conditions", @"Jaw Pain", @"Jaw Swelling", @"Jaw Symptoms", @"Joint Pain", @"Joint Swelling", @"Joint Symptoms", @"Jugular Vein Distention", @"Kidney Disease", @"Kidney Failure", @"Kidney Pain", @"Kidney Stones", @"Kidney Symptoms", @"Knee Burning Sensation", @"Knee Injury", @"Knee Lump", @"Knee Pain", @"Knee Sprain", @"Knee Swelling", @"Knee Symptoms", @"Knuckle Pain", @"Kwashiorkor", @"Lack of Energy", @"Lactic Acidosis", @"Lactose Intolerance", @"Lead Poisoning", @"Learning Disabilities", @"Left Lower Quadrant Pain", @"Leg Bruise", @"Leg Burning Sensation", @"Leg Cramps", @"Leg Lump", @"Leg Numbness", @"Leg Pain", @"Leg Pain in Children", @"Leg Paresthesia", @"Leg Rash", @"Leg Swelling", @"Leg Symptoms", @"Leg Weakness", @"Leptospirosis", @"Lethargy", @"Leukemia", @"Lichen Planus", @"Lichen Sclerosus", @"Light Periods", @"Lip Burning Sensation", @"Lip Cancer", @"Lip Sore", @"Lip Swelling", @"Lip Symptoms", @"Lipoma", @"Liver Abscess", @"Liver Cancer", @"Liver Disease", @"Liver Failure", @"Liver Inflammation", @"Liver Pain", @"Liver Symptoms", @"Loss of Smell", @"Loss of Taste", @"Loss of Voice", @"Low Blood Pressure", @"Low Sodium", @"Low White Blood Cell Count", @"Low-Grade Fever", @"Lower Abdominal Pain", @"Lower Back Pain", @"Lump", @"Lung Cancer", @"Lung Symptoms", @"Lupus", @"Lyme Disease", @"Lymph Symptoms", @"Lymphadenitis", @"Lymphatic Filariasis", @"Lymphoma", @"Macrocytosis", @"Magnesium Overdose", @"Malabsorption", @"Malaise", @"Malaria", @"Marasmus", @"Mastitis", @"Meal Symptoms", @"Measles", @"Melanoma", @"Meningitis", @"Meningococcal Disease", @"Menopause", @"Menstrual Irregularities", @"Meralgia Paresthetica", @"Mesenteric Adenitis", @"Metabolic Disorders", @"Metallic Taste", @"Middle Back Pain", @"Middle Ear Infection", @"Migraine", @"Miscarriage", @"Molluscum Contagiosum", @"Mononucleosis", @"Mood Disorders", @"Mood Swings", @"Motor Neuron Diseases", @"Mouth Redness", @"Mouth Symptoms", @"Mouth Ulcers", @"Mouth White Patches", @"Mucus Symptoms", @"Mucus in Stool", @"Multiple Myeloma", @"Multiple Sclerosis", @"Mumps", @"Muscle Aches", @"Muscle Atrophy", @"Muscle Conditions", @"Muscle Cramps", @"Muscle Pain", @"Muscle Spasms", @"Muscle Symptoms", @"Muscle Twitch", @"Muscle Weakness", @"Myasthenia Gravis", @"Myoma (Fibroid)", @"Myopathy", @"Myxedema", @"Nail Ridges", @"Nail Symptoms", @"Nausea", @"Neck Injury", @"Neck Itch", @"Neck Lump", @"Neck Pain", @"Neck Rash", @"Neck Spasm", @"Neck Swelling", @"Neck Symptoms", @"Nephrotic Syndrome", @"Nerve Conditions", @"Nerve Symptoms", @"Nervous Breakdown", @"Neuralgia", @"Neurodermatitis", @"Neurological Symptoms", @"Neuropathy", @"Night Cough", @"Night Sweats", @"Nipple Itch", @"Nipple Pain", @"Nipple Symptoms", @"Nocturia", @"Nose Burning Sensation", @"Nose Symptoms", @"Nosebleeds", @"Numb Face", @"Numb Lips", @"Numb Thigh", @"Numbness", @"Nymphomania", @"Nystagmus", @"Obesity", @"Obsessive Compulsive Disorder", @"Obstructive Jaundice", @"Occipital Neuralgia", @"Odor Symptoms", @"Optic Nerve Damage", @"Oral Cancer", @"Oral Thrush", @"Orange Urine", @"Osteoarthritis", @"Osteomalacia", @"Osteomyelitis", @"Osteoporosis", @"Otitis Externa", @"Ovarian Cancer", @"Pain", @"Painful Intercourse", @"Painful Swallowing", @"Pale Stool", @"Paleness", @"Palm Pain", @"Palm Rash", @"Palpitations", @"Pancreas Symptoms", @"Pancreatic Cancer", @"Pancreatitis", @"Pancytopenia", @"Panic Attack", @"Papilloma", @"Paralysis Symptoms", @"Paralytic Ileus", @"Paranoia", @"Paresthesia", @"Parkinson's Disease", @"Parotid Gland Cancer", @"Parotitis", @"Peeling Skin", @"Peeling Skin on Hands and Feet in Children", @"Pellagra", @"Pelvic Cancer", @"Pelvic Inflammatory Disease", @"Pelvic Pain", @"Pencil Thin Stools", @"Penicillin Allergy", @"Penile Burning Sensation", @"Penile Itch", @"Penile Rash", @"Penis Discharge", @"Penis Pain", @"Penis Swelling", @"Penis Symptoms", @"Peptic Ulcer", @"Perforated Eardrum", @"Perimenopause", @"Peripheral Neuropathy", @"Peripheral Vascular Disease", @"Peripheral Vision Loss", @"Pernicious Anemia", @"Persistent Cough", @"Personality Change", @"Petechiae", @"Pharyngitis", @"Phimosis", @"Phlegm Symptoms", @"Pinched Nerve", @"Pituitary Symptoms", @"Pleurisy", @"Pneumonia", @"Polio", @"Polycythemia", @"Polymyalgia Rheumatica", @"Poor Appetite", @"Porphyria", @"Posterior Vitreous Detachment", @"Postnasal Drip", @"Pregnancy", @"Pregnancy Symptoms", @"Pressure In Head", @"Prostate Cancer", @"Prostate Pain", @"Prostatitis", @"Proteinuria", @"Pruritus", @"Psoriasis", @"Psychiatric Disorders", @"Psychological Disorders", @"Psychosomatic Illness", @"Pubic Lice", @"Puffy Eyes", @"Pulmonary Edema", @"Pulmonary Embolism", @"Pupil Dilation", @"Pupil Symptoms", @"Purple Skin", @"Pus", @"Pustules", @"Pyelonephritis", @"Rabies", @"Rapid Heartbeat", @"Rash", @"Raynaud’s Phenomenon", @"Rectal Bleeding", @"Rectal Cancer", @"Rectal Discharge", @"Rectal Lump", @"Red Eye", @"Red Eyelids", @"Red Face", @"Red Nose", @"Red Spots", @"Reflex Sympathetic Dystrophy Syndrome", @"Renal Colic", @"Respiratory Failure", @"Respiratory Symptoms", @"Retinal Detachment", @"Rheumatoid Arthritis", @"Rib Fracture", @"Rib Pain", @"Rickets", @"Rodent Ulcer", @"Rosacea", @"Runny Nose", @"STDs", @"Salmonella Food Poisoning", @"Salt Craving", @"Sarcoidosis", @"Scabies", @"Scabs", @"Scalp Pain", @"Scalp Symptoms", @"Scaly Skin", @"Scarlet Fever", @"Schizophrenia", @"Schwannoma", @"Sciatica", @"Scleroderma", @"Scoliosis", @"Scurvy", @"Sebaceous Cyst", @"Seeing Spots", @"Seizures", @"Sensitive Teeth", @"Septicemia", @"Seroma", @"Shaky Hands", @"Shin Pain", @"Shingles", @"Shock", @"Shortness of Breath", @"Shoulder Pain", @"Shoulder Symptoms", @"Sickle Cell Anemia", @"Side Pain", @"Simple Kidney Cysts", @"Sinus Arrhythmia", @"Sinus Cancer", @"Sinusitis", @"Sjogrens Syndrome", @"Skin Bumps", @"Skin Cancer", @"Skin Color Changes", @"Skin Conditions", @"Skin Lesion", @"Skin Pain", @"Skin Symptoms", @"Slapped Cheek Syndrome", @"Sleep Apnea", @"Slow Heartbeat", @"Slurred Speech", @"Small Intestine Cancer", @"Smoking", @"Sneezing", @"Sore Eyes", @"Sore Gums", @"Sore Throat", @"Sore Tongue", @"Sore Vagina", @"Sores", @"Spasms", @"Speech Symptoms", @"Spinal Cord Tumor", @"Spinal Stenosis", @"Spine Symptoms", @"Spitting Blood", @"Spleen Cancer", @"Spondylosis", @"Spotting", @"Sputum Symptoms", @"Steatorrhea", @"Stiff Joints", @"Stiff Knee", @"Stiff Neck", @"Stomach Ache", @"Stomach Cancer", @"Stomach Cramps", @"Stomach Problems", @"Stomach Rash", @"Stool Color", @"Stool Odor", @"Stool Symptoms", @"Strain", @"Strep Throat", @"Stress", @"Stroke", @"Stuffed Nose", @"Subdural Hematoma", @"Sugar in Urine", @"Swallowing Difficulty", @"Sweating", @"Swelling Symptoms", @"Swollen Finger", @"Swollen Gums", @"Swollen Lymph Nodes", @"Swollen Neck Lymph Nodes", @"Swollen Spleen", @"Swollen Testes", @"Swollen Tongue", @"Syphilis", @"Tapeworm Infection", @"Tardive Dyskinesia", @"Taste Symptoms", @"Temporal Arteritis", @"Tendinitis", @"Testicle Lump", @"Testicle Pain", @"Testicular Cancer", @"Testicular Torsion", @"Tetanus", @"Tetany", @"Thiamine Deficiency", @"Thigh Burning Sensation", @"Thigh Lump", @"Thigh Pain", @"Thigh Rash", @"Thigh Symptoms", @"Thirst", @"Throat Cancer", @"Throat Clearing", @"Throat Infection", @"Throat Pain", @"Throat Symptoms", @"Throat Ulcers", @"Throat White Patches", @"Throbbing Headache", @"Thrombocytopenia", @"Thumb Pain", @"Thyroid Disorders", @"Tinea", @"Tingling", @"Tingling Face", @"Tingling Fingers", @"Tingling Lips", @"Tingling Toe", @"Tingling in Both Feet", @"Tingling in Both Hands", @"Tingling in One Foot", @"Tingling in One Hand", @"Tingling tongue", @"Tinnitus", @"Toe Burning Sensation", @"Toe Numbness", @"Toe Pain", @"Toe Swelling", @"Toe Symptoms", @"Toenail Symptoms", @"Tongue Cancer", @"Tongue Symptoms", @"Tongue Ulcers", @"Tonsil Cancer", @"Tonsil Symptoms", @"Tooth Abscess", @"Torn Rotator Cuff", @"Traumatic Brain Injury", @"Tremor Symptoms", @"Trichomoniasis", @"Trigeminal Neuralgia", @"Tuberculosis", @"Twitches", @"Typhoid Fever", @"Ulcerative colitis", @"Ulnar Nerve Injury", @"Underarm Itch", @"Underarm Lump", @"Underarm Pain", @"Underarm Rash", @"Underarm Symptoms", @"Upper Abdominal Pain", @"Upper Arm Pain", @"Upper Back Pain", @"Upper Respiratory Infection", @"Uremia", @"Urethral Stricture", @"Urethritis", @"Urinary Burning", @"Urinary Disorders", @"Urinary Symptoms", @"Urinary Urgency", @"Urination Pain", @"Urine Color Changes", @"Urine Odor", @"Urine Retention", @"Urosepsis", @"Uterine Cancer", @"Uterine Fibroids", @"Uterine Prolapse", @"Vaginal Bleeding", @"Vaginal Bleeding After Menopause", @"Vaginal Burning Sensation", @"Vaginal Cancer", @"Vaginal Candidiasis", @"Vaginal Discharge", @"Vaginal Itching", @"Vaginal Odor", @"Vaginal Pain", @"Vaginal Rash", @"Vaginal Swelling", @"Vaginal Symptoms", @"Vaginitis", @"Vague Symptoms", @"Varicose Veins", @"Vasomotor Rhinitis", @"Vasovagal Attack", @"Vein Pain", @"Ventral Hernia", @"Vertigo", @"Viral Diseases", @"Vision Changes", @"Vision Distortion", @"Vision Loss", @"Vitamin B12 Deficiency", @"Vitamin D Deficiency", @"Vitiligo", @"Vomiting", @"Vomiting Blood", @"Vulva Itch", @"Watery Eye", @"Weakness", @"Weight Gain", @"Weight Loss", @"Wet Cough", @"Wheat Intolerance", @"Wheezing", @"White Patches", @"White Stool", @"White Tongue", @"Whitlow", @"Whooping Cough", @"Wrist Lump", @"Wrist Pain", @"Yawning Excessively", @"Yellow Eyes", @"Yellow Stool", @"Zinc Deficiency", @"Zinc Poisoning", nil];
    
    self.allItems = items;
    [self.tableView reloadData];
    
    // Make the background view of the search bar transparent
    [searchBar setBackgroundImage:[UIImage new]];
    [searchBar setTranslucent:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if ([tableView
         isEqual:self.searchDisplayController.searchResultsTableView]){
        rows = [self.searchResults count];
    }
    else{
        rows = [self.allItems count];
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        cell.textLabel.text = [self.searchResults objectAtIndex:indexPath.row];
    }
    else {
        cell.textLabel.text = [self.allItems objectAtIndex:indexPath.row];
    }
    
    //Set the right accessory view depending on presence in symptom array
    NSMutableArray *symptomCopy = [DataController sharedClient].symptomArray;
    
    if ([symptomCopy containsObject:cell.textLabel.text])
    {
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        [button addTarget:self action:@selector(accessoryButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = button;
    }
    
    return cell;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    
    self.searchResults = [self.allItems filteredArrayUsingPredicate:resultPredicate];
}

#pragma mark - UISearchDisplayController delegate methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:searchOption]];
    
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Action functions

- (IBAction)doneButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)accessoryButtonTapped:(UIButton *)sender {
    
    //Get index path for selected cell
    UITableViewCell *cell = (UITableViewCell *)sender.superview;
    
    if ([cell.superview isEqual:self.searchDisplayController.searchResultsTableView]){
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForCell:cell];
        
        //Change accessory to checkmark
        [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath].accessoryView = nil;
        [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.tableView reloadData];
        
        NSString *symptom = [self.searchResults objectAtIndex:[indexPath row]];
        [[DataController sharedClient].symptomArray addObject:symptom];
        NSLog(@"Adding %@ to the symptom array.", symptom);
    }
    else {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        //Change accessory to checkmark
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryView = nil;
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        
        NSString *symptom = [self.allItems objectAtIndex:[indexPath row]];
        [[DataController sharedClient].symptomArray addObject:symptom];
        NSLog(@"Adding %@ to the symptom array.", symptom);
    }
    
}
@end
