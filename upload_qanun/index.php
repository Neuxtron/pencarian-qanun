<?php
/**
 * Simple universal file-receiver.
 * Place this file in a web-accessible folder and POST files to it.
 * All successfully-uploaded files are moved to $targetDir.
 */

$targetDir = dirname(__DIR__) . '/qanun';       // change this folder if you like
$maxDirPermissions = 0755;                      // permissions when we create the folder
header('Content-Type: application/json');

// 1. Make sure the destination directory exists.
if (!is_dir($targetDir) && !mkdir($targetDir, $maxDirPermissions, true)) {
    http_response_code(500);
    exit(json_encode([
      'status' => false,
      'message' => 'Cannot create upload directory.',
      'data' => null,
    ]));
}

// 2. Bail out if no file data present.
if (empty($_FILES)) {
    http_response_code(400);
    exit(json_encode([
      'status' => false,
      'message' => 'No files received.',
      'data' => null,
    ]));
}

$results = [];

foreach ($_FILES as $fieldName => $fileInfo) {
    // Handle single or multiple uploads under the same field name.
    $fileCount = is_array($fileInfo['name']) ? count($fileInfo['name']) : 1;

    for ($i = 0; $i < $fileCount; $i++) {
        // Normalize single vs. multiple.
        $name     = is_array($fileInfo['name'])     ? $fileInfo['name'][$i]     : $fileInfo['name'];
        $tmpName  = is_array($fileInfo['tmp_name'])  ? $fileInfo['tmp_name'][$i]  : $fileInfo['tmp_name'];
        $error    = is_array($fileInfo['error'])    ? $fileInfo['error'][$i]    : $fileInfo['error'];
        $size     = is_array($fileInfo['size'])     ? $fileInfo['size'][$i]     : $fileInfo['size'];

        if ($error !== UPLOAD_ERR_OK) {
            $results[] = [
                'file'    => $name,
                'status'  => 'error',
                'message' => 'Upload error code ' . $error
            ];
            continue;
        }

        // Optional: prevent overwriting by prefixing a timestamp + random string
        // $safeName = preg_replace('/[^A-Za-z0-9.\-_]/', '_', $name);      // crude sanitization
        // $destName = time() . '_' . bin2hex(random_bytes(4)) . '__' . $safeName;
        // $destPath = $targetDir . '/' . $destName;
        $destPath = $targetDir . '/' . $name;

        if (move_uploaded_file($tmpName, $destPath)) {
            $results[] = [
                'file'   => $name,
                'stored' => basename($destPath),
                'size'   => $size,
                'status' => 'success'
            ];
        } else {
            $results[] = [
                'file'    => $name,
                'status'  => 'error',
                'message' => 'Failed to move file.'
            ];
        }
    }
}

http_response_code(201);
echo json_encode([
    'status'  => true,
    'messsage' => 'Successfully uploaded files.',
    'data' => $results
]);
